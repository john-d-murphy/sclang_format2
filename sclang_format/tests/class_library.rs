//! SuperCollider's own class library, formatted: real files, long and
//! written by many hands, where the help snippets are short. Each file must
//! format without a rule breaking it, come out the same from a second pass,
//! and keep every token.

mod common;

use common::tokens::changed_tokens;
use glob::glob;
use std::path::Path;
use tree_sitter::Parser;

const LIBRARY: &str = "/usr/share/SuperCollider/SCClassLibrary";

/// The files the grammar cannot parse yet, relative to the library. The list
/// must be exact: a file that parses now, or one that has stopped parsing,
/// fails the test. To regenerate it, run `cargo test --test class_library`:
/// when the list is wrong, the failure prints it as it should be.
const KNOWN_PARSE_FAILURES: &[&str] = &[
    "Common/Audio/Bela/BelaUGens.sc",
    "Common/Audio/Env.sc",
    "Common/Audio/InOut.sc",
    "Common/Audio/Noise.sc",
    "Common/Audio/SynthDef.sc",
    "Common/Audio/SynthDesc.sc",
    "Common/Collections/Array.sc",
    "Common/Collections/ArrayedCollection.sc",
    "Common/Collections/Bag.sc",
    "Common/Collections/Collection.sc",
    "Common/Collections/Dictionary.sc",
    "Common/Collections/Event.sc",
    "Common/Collections/Interval.sc",
    "Common/Collections/LinkedList.sc",
    "Common/Collections/SequenceableCollection.sc",
    "Common/Collections/Set.sc",
    "Common/Collections/SortedList.sc",
    "Common/Collections/SparseArray.sc",
    "Common/Collections/String.sc",
    "Common/Control/Buffer.sc",
    "Common/Control/Engine.sc",
    "Common/Control/HIDFunc.sc",
    "Common/Control/MIDIResponder.sc",
    "Common/Control/ResponseDefs.sc",
    "Common/Control/SerialPort.sc",
    "Common/Control/Server.sc",
    "Common/Control/asScore/asScore.sc",
    "Common/Core/AbstractFunction.sc",
    "Common/Core/Condition.sc",
    "Common/Core/Function.sc",
    "Common/Core/Kernel.sc",
    "Common/Core/Object.sc",
    "Common/Files/SoundFile.sc",
    "Common/GUI/Base/Grid.sc",
    "Common/GUI/Base/QImage.sc",
    "Common/GUI/Base/QLayout.sc",
    "Common/GUI/Base/QMultiSliderView.sc",
    "Common/GUI/Base/QTextView.sc",
    "Common/GUI/PlusGUI/Control/scopeResponse.sc",
    "Common/Math/Integer.sc",
    "Common/Streams/FilterPatterns.sc",
    "Common/Streams/IOStream.sc",
    "Common/Streams/PatternConductor.sc",
    "Common/Streams/Plambda.sc",
    "Common/Streams/RandomDistPatterns.sc",
    "Common/Streams/Stream.sc",
    "Common/UnitTesting/UnitTest.sc",
    "DefaultLibrary/dumpFullInterface.sc",
    "JITLib/GUI/EnvirGui.sc",
    "JITLib/GUI/NdefGui.sc",
    "JITLib/Patterns/Fdef.sc",
    "JITLib/Patterns/OpFunctionProxy.sc",
    "JITLib/Patterns/Pdef.sc",
    "JITLib/Patterns/extPostAsCode.sc",
    "JITLib/ProxySpace/NodeMap.sc",
    "JITLib/ProxySpace/NodeProxy.sc",
    "JITLib/ProxySpace/ProxyInterfaces.sc",
    "JITLib/ProxySpace/TempoBusClock.sc",
    "JITLib/ProxySpace/wrapForNodeProxy.sc",
    "SCDoc/SCDoc.sc",
    "deprecated/3.10/deprecated-3.10.sc",
    "scide_scqt/ScIDE.sc",
];

fn parses(parser: &mut Parser, src: &str) -> bool {
    !parser.parse(src, None).unwrap().root_node().has_error()
}

#[test]
fn class_library_formats_cleanly() {
    if !Path::new(LIBRARY).is_dir() {
        eprintln!("skipping class_library_formats_cleanly: no class library at {LIBRARY}");
        return;
    }
    let mut parser = Parser::new();
    parser
        .set_language(&sclang_format::grammar::language())
        .unwrap();

    let mut paths: Vec<_> = glob(&format!("{LIBRARY}/**/*.sc"))
        .unwrap()
        .map(Result::unwrap)
        .collect();
    paths.sort();
    assert!(!paths.is_empty(), "no .sc files under {LIBRARY}");

    let mut unparsed = Vec::new();
    let mut faults = Vec::new();
    for path in &paths {
        let name = path.strip_prefix(LIBRARY).unwrap().display().to_string();
        let input = std::fs::read_to_string(path).unwrap();
        if !parses(&mut parser, &input) {
            unparsed.push(name);
            continue;
        }
        let once = match sclang_format::format_source(&input, "all") {
            Ok(out) => out,
            Err(e) => {
                faults.push(format!("{name}: refused: {e:#}"));
                continue;
            }
        };
        match sclang_format::format_source(&once, "all") {
            Ok(twice) if twice != once => faults.push(format!("{name}: a second pass changes it")),
            Ok(_) => {}
            Err(e) => faults.push(format!("{name}: second pass refused: {e:#}")),
        }
        let changed = changed_tokens(&input, &once);
        if !changed.is_empty() {
            faults.push(format!("{name}: tokens changed: {}", changed.join(", ")));
        }
    }

    eprintln!(
        "class library: {} files, {} formatted, {} the grammar cannot parse yet, {} faults",
        paths.len(),
        paths.len() - unparsed.len(),
        unparsed.len(),
        faults.len()
    );

    let newly_parsing: Vec<_> = KNOWN_PARSE_FAILURES
        .iter()
        .filter(|k| !unparsed.iter().any(|u| u == *k))
        .collect();
    let newly_unparsed: Vec<_> = unparsed
        .iter()
        .filter(|u| !KNOWN_PARSE_FAILURES.contains(&u.as_str()))
        .collect();
    if !newly_parsing.is_empty() || !newly_unparsed.is_empty() {
        faults.push(format!(
            "KNOWN_PARSE_FAILURES is out of date.\n\
             Parse now, remove: {newly_parsing:?}\n\
             Do not parse, add: {newly_unparsed:?}\n\
             The list as it should be:\n\
             const KNOWN_PARSE_FAILURES: &[&str] = &[\n{}];",
            unparsed
                .iter()
                .map(|u| format!("    {u:?},\n"))
                .collect::<String>()
        ));
    }

    assert!(faults.is_empty(), "\n{}", faults.join("\n"));
}

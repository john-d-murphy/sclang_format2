use sclang_format::grammar;
use tree_sitter::Parser;

fn dump_tree(node: tree_sitter::Node, src: &str, indent: usize) {
    let indent_str = "  ".repeat(indent);
    let start = node.start_byte();
    let end = node.end_byte().min(start + 40);
    let text = &src[start..end];
    let text_preview = text.replace('\n', "\\n");

    println!(
        "{}{} [{}-{}] {:?}",
        indent_str,
        node.kind(),
        node.start_byte(),
        node.end_byte(),
        if text_preview.len() > 30 {
            format!("{}...", &text_preview[..30])
        } else {
            text_preview
        }
    );

    for i in 0..node.child_count() {
        if let Some(child) = node.child(i) {
            dump_tree(child, src, indent + 1);
        }
    }
}

fn dump_ast(src: &str) {
    let mut parser = Parser::new();
    parser
        .set_language(&grammar::language())
        .expect("set language");

    println!("\n============================================================");
    println!("SOURCE: {}", src);
    println!("============================================================");

    let tree = parser.parse(src, None).expect("parse");
    let root = tree.root_node();

    if root.has_error() {
        println!("⚠️  PARSE ERROR in tree");
    }

    dump_tree(root, src, 0);
}

#[test]
fn dump_problematic_asts() {
    // Case 1: while loop
    dump_ast("while (x > 0) { body }");

    // Case 2: receiver block
    dump_ast("{ body }.value");

    // Case 3: trailing closure
    dump_ast("[1,2,3].do { |x| x.postln }");

    // Case 4: nested trailing closures
    dump_ast("[1,2,3].do { |x| [x].do { |y| y } }");

    // Case 5: class definition
    dump_ast("MyClass { *new { ^super.new } }");

    // Case 6: if statement
    dump_ast("if (cond) { true } { false }");

    // Case 7: event with method
    dump_ast("( freq: 440 ).play");

    // Case 8: standalone code block with parens
    dump_ast("(\n    (a + b) * (c - d)\n).postln");

    // Case 9: multiline event
    dump_ast("(\n    freq: 440,\n    amp: 0.1\n).play");
}

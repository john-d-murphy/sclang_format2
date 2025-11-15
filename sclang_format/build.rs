use std::{env, path::PathBuf};

fn main() {
    // CARGO_MANIFEST_DIR is the crate root (…/sclang_format)
    let manifest_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());

    // Our submodule lives at ../vendor/tree-sitter-supercollider
    let grammar = manifest_dir
        .join("..")
        .join("vendor")
        .join("tree-sitter-supercollider");

    let parser = grammar.join("src/parser.c");
    let scanner_cc = grammar.join("src/scanner.cc");
    let scanner_c = grammar.join("src/scanner.c");

    let mut build = cc::Build::new();
    build.include(grammar.join("src"));
    build.file(&parser);
    build.flag_if_supported("-Wno-unused-parameter");
    build.flag_if_supported("-Wno-unused-function");
    build.flag_if_supported("-Wno-unused-variable");
    build.extra_warnings(false);

    if scanner_cc.exists() {
        build.file(scanner_cc);
        build.cpp(true);
    } else if scanner_c.exists() {
        build.file(scanner_c);
    }

    build.compile("tree-sitter-supercollider");

    println!("cargo:rerun-if-changed={}", grammar.join("src").display());
}

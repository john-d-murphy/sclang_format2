use tree_sitter::Language;

unsafe extern "C" {
        fn tree_sitter_supercollider() -> Language;
}

pub fn language() -> Language {
        unsafe { tree_sitter_supercollider() }
}

// src/engine/ast_utils.rs
use tree_sitter::Node;


/// Iterator over a node and its ancestors, up to the root.
pub struct Ancestors<'a> {
    next: Option<Node<'a>>,
}


impl<'a> Iterator for Ancestors<'a> {
    type Item = Node<'a>;


    fn next(&mut self) -> Option<Self::Item> {
        let current = self.next?;
        self.next = current.parent();
        Some(current)
    }
}


/// Extra convenience methods on `tree_sitter::Node`.
pub trait NodeExt<'a> {
    fn ancestors_inclusive(self) -> Ancestors<'a>;
    fn has_ancestor_kind(self, kind: &str) -> bool;
    fn nearest_ancestor_kind(self, kind: &str) -> Option<Node<'a>>;
    fn has_descendant_kind(self, kind: &str) -> bool;
    fn is_collection(self) -> bool;
    fn is_indexing(self) -> bool;
}


impl<'a> NodeExt<'a> for Node<'a> {
    fn ancestors_inclusive(self) -> Ancestors<'a> {
        Ancestors { next: Some(self) }
    }


    fn has_ancestor_kind(self, kind: &str) -> bool {
        self.ancestors_inclusive().any(|n| n.kind() == kind)
    }


    fn nearest_ancestor_kind(self, kind: &str) -> Option<Node<'a>> {
        self.ancestors_inclusive().find(|n| n.kind() == kind)
    }


    fn has_descendant_kind(self, kind: &str) -> bool {
        let mut stack = vec![self];
        while let Some(node) = stack.pop() {
            if node.kind() == kind {
                return true;
            }
            let child_count = node.child_count();
            for i in 0..child_count {
                if let Some(child) = node.child(i) {
                    stack.push(child);
                }
            }
        }
        false
    }


    fn is_collection(self) -> bool {
        self.kind() == "collection"
    }


    fn is_indexing(self) -> bool {
        matches!(self.kind(), "indexed_collection" | "index_subrange")
    }
}


/// High-level classification for `collection` nodes.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CollectionKind {
    Array,
    Event,
    Other,
}


pub fn classify_collection<'a>(node: Node<'a>, src: &[u8]) -> Option<CollectionKind> {
    if node.kind() != "collection" {
        return None;
    }
    let start = node.start_byte() as usize;
    let open = *src.get(start)?;


    match open {
        b'[' => {
            if node.has_descendant_kind("associative_item") {
                Some(CollectionKind::Other)
            } else {
                Some(CollectionKind::Array)
            }
        }
        b'(' => {
            if node.has_descendant_kind("associative_item") {
                Some(CollectionKind::Event)
            } else {
                Some(CollectionKind::Other)
            }
        }
        _ => Some(CollectionKind::Other),
    }
}


/// Helper to determine if a node is "top-level" in the file.
///
/// A node is top-level if its ancestry chain to `source_file` consists ONLY
/// of "transparent" wrapper nodes. If we hit a functional block, definition,
/// or assignment, we are NOT top-level.
fn is_top_level_node(node: Node) -> bool {
    let mut curr = node.parent();
    while let Some(n) = curr {
        let k = n.kind();
        if k == "source_file" {
            return true;
        }
        // These are "transparent" structure nodes
        if matches!(
            k,
            "_expression_sequence"
                | "_expression"
                | "expression_statement"
                | "_expression_statement"
                | "_paren_expression_list"
        ) {
            curr = n.parent();
        } else {
            // We hit a logic block (like function_definition, function_block, etc.)
            // So we are definitely NOT top level.
            return false;
        }
    }
    false
}


/// Count enclosing nodes that represent block-like scopes.
pub fn block_depth_at(root: Node, byte: usize, src: &[u8]) -> usize {
    let mut depth = 0usize;


    // Track the start rows of ALL enclosing block types.
    // When we reach a parameter_call_list, we skip it if ANY
    // function_block or collection started on the same line.
    let mut function_block_start_rows: Vec<usize> = Vec::new();
    let mut collection_start_rows: Vec<usize> = Vec::new();


    let Some(mut node) = root.descendant_for_byte_range(byte, byte + 1) else {
        return 0;
    };


    loop {
        match node.kind() {
            // Function blocks indent their content (but not the opening brace itself)
            "function_block" => {
                // Only count if we're past the opening brace
                if byte > node.start_byte() {
                    depth += 1;
                    function_block_start_rows.push(node.start_position().row);
                }
            }


            // Class definitions have their own body delimited by { }
            // Only count if we're inside the braces (after the opening {)
            "class_def" => {
                // Find the opening brace
                for i in 0..node.child_count() {
                    if let Some(child) = node.child(i) {
                        if child.kind() == "{" {
                            // Only count if byte is after the opening brace
                            if byte > child.start_byte() {
                                depth += 1;
                            }
                            break;
                        }
                    }
                }
            }


            // Events indent their content (but not the opening paren itself)
            "event" => {
                if byte > node.start_byte() {
                    depth += 1;
                }
            }


            // Indexed collections add structural depth
            "indexed_collection" => {
                if byte > node.start_byte() {
                    depth += 1;
                }
            }


            // Grouping parens `( ... )`.
            // Count these UNLESS they are the top-level wrapper of the file.
            "code_block" => {
                if !is_top_level_node(node) && byte > node.start_byte() {
                    depth += 1;
                }
            }


            // Collections `[ ... ]` or `( ... )` add structural depth
            "collection" => {
                if byte > node.start_byte() {
                    if let Some(first) = src.get(node.start_byte()) {
                        if *first == b'[' {
                            // Array literals
                            depth += 1;
                            collection_start_rows.push(node.start_position().row);
                        } else if *first == b'(' {
                            // Arithmetic series `(1..10)` or other paren-like collections.
                            // Count unless top-level.
                            if !is_top_level_node(node) {
                                depth += 1;
                                collection_start_rows.push(node.start_position().row);
                            }
                        }
                    }
                }
            }


            // Multi-line function calls: Pbind(\n    \degree, ...\n)
            // Count parameter_call_list if it spans multiple lines
            // BUT only if we're directly in the param list, not inside a nested block
            // that started on the SAME line as the param list
            "parameter_call_list" => {
                if byte >= node.start_byte() {
                    // Check if this is a multi-line call by comparing start/end rows
                    let start_row = node.start_position().row;
                    let end_row = node.end_position().row;
                    if start_row != end_row {
                        // Check if ANY inner block started on the SAME line as this param_list
                        // If so, that block handles the indentation, skip param_list
                        let block_on_same_line =
                            function_block_start_rows.iter().any(|&r| r == start_row)
                            || collection_start_rows.iter().any(|&r| r == start_row);


                        if !block_on_same_line {
                            depth += 1;
                        }
                    }
                }
            }


            _ => {}
        }


        if let Some(parent) = node.parent() {
            node = parent;
        } else {
            break;
        }
    }


    depth
}


/// Returns a visual indentation depth (AST block depth adjusted for layout rules).
pub fn visual_block_depth_at(root: Node, byte: usize, bytes: &[u8]) -> usize {
    let depth = block_depth_at(root, byte, bytes);
    let mut visual_depth = depth;


    // Find the smallest node covering this byte.
    let Some(node) = root.descendant_for_byte_range(byte, byte + 1) else {
        return visual_depth;
    };


    let mut ancestors: Vec<Node> = Vec::new();
    let mut cur = Some(node);
    while let Some(n) = cur {
        ancestors.push(n);
        cur = n.parent();
    }


    // Flags for layout adjustments
    let mut has_fn_block = false;
    let mut has_collection = false;
    let mut has_event = false;
    let mut collection_ancestor: Option<Node> = None;
    let mut event_ancestor: Option<Node> = None;


    for n in &ancestors {
        match n.kind() {
            "function_block" => has_fn_block = true,
            "collection" => {
                has_collection = true;
                if collection_ancestor.is_none() {
                    collection_ancestor = Some(*n);
                }
            }
            "event" => {
                has_event = true;
                if event_ancestor.is_none() {
                    event_ancestor = Some(*n);
                }
            }
            _ => {}
        }
    }


    let mut is_collection_receiver = false;
    if let Some(collection) = collection_ancestor {
        if let Some(parent) = collection.parent() {
            if parent.kind() == "function_call" {
                is_collection_receiver = true;
            }
        }
    }


    // 1. Check for multiline grouping parens that need flattening.
    let mut inside_multiline_paren_group = false;
    let mut paren_group_ancestor: Option<Node> = None;


    for n in &ancestors {
        let kind = n.kind();
        if kind == "collection" || kind == "code_block" {
            let start = n.start_byte() as usize;
            if let Some(b'(') = bytes.get(start) {
                // Ignore top-level parens (depth already 0 via block_depth_at)
                if !is_top_level_node(*n) {
                    let start_row = n.start_position().row;
                    let end_row = n.end_position().row;
                    if end_row > start_row {
                        inside_multiline_paren_group = true;
                        paren_group_ancestor = Some(*n);
                        break;
                    }
                }
            }
        }
    }


    let mut flattened_for_paren_group = false;


    if inside_multiline_paren_group {
        if let Some(paren_group) = paren_group_ancestor {
            let innermost = ancestors[0];


            // Don't flatten the paren group wrapper itself
            let is_the_wrapper_token = (innermost.start_byte() == paren_group.start_byte())
                || (innermost.end_byte() == paren_group.end_byte());


            // Only flatten for events inside paren groups, not collections
            // Collections are handled separately by single-line flattening
            // IMPORTANT: Only flatten if we're actually inside the event (not at its opening paren)
            if !is_the_wrapper_token && visual_depth > 0 {
                if let Some(ev) = event_ancestor {
                    if byte > ev.start_byte() {
                        visual_depth -= 1;
                        flattened_for_paren_group = true;
                    }
                }
            }
        }
    }


    // 2. Indent `switch` cases
    let innermost = ancestors[0];
    if innermost.kind() != "switch" {
        if ancestors
            .iter()
            .any(|n| n.kind() == "switch" && n.child_count() > 0)
        {
            visual_depth += 1;
        }
    }


    // 3. Flatten inline arrays of events
    // Only flatten if we're inside the event (not at its opening paren)
    if has_collection && has_event && !has_fn_block {
        if let Some(ev) = event_ancestor {
            if byte > ev.start_byte() {
                let start_row = ev.start_position().row;
                let end_row = ev.end_position().row;
                if start_row == end_row && visual_depth > 0 {
                    visual_depth -= 1;
                }
            }
        }
    }


    // 4. Flatten single-line collections and indexed_collections
    // Single-line brackets don't add visual indent
    // But skip if we already flattened for paren group
    // IMPORTANT: Only flatten if the collection actually contributed to depth
    // (i.e., we're inside it, not at its opening bracket)
    let mut flattened_single_line = false;


    if !flattened_for_paren_group {
        if let Some(coll) = collection_ancestor {
            // Only flatten if we're INSIDE the collection (not at the opening bracket)
            if byte > coll.start_byte() {
                let start_row = coll.start_position().row;
                let end_row = coll.end_position().row;
                if start_row == end_row && visual_depth > 0 {
                    visual_depth -= 1;
                    flattened_single_line = true;
                }
            }
        }
    }


    if !flattened_single_line && !flattened_for_paren_group {
        for n in &ancestors {
            if n.kind() == "indexed_collection" {
                // Only flatten if we're INSIDE the indexed_collection
                if byte > n.start_byte() {
                    let start_row = n.start_position().row;
                    let end_row = n.end_position().row;
                    if start_row == end_row && visual_depth > 0 {
                        visual_depth -= 1;
                    }
                }
                break;
            }
        }
    }


    // 5. Flatten collection receivers (e.g. `[1, 2].do`) at top level
    // Only flatten when NOT inside a function_block AND not already flattened
    // AND we're actually inside the collection (not at its opening bracket)
    if is_collection_receiver
        && !has_event
        && !has_fn_block
        && !flattened_single_line
        && visual_depth > 0
    {
        if let Some(coll) = collection_ancestor {
            if byte > coll.start_byte() {
                visual_depth -= 1;
            }
        }
    }


    visual_depth
}


#[cfg(test)]
mod tests {
    use super::*;
    use tree_sitter::Parser;


    fn parse_source(src: &str) -> (tree_sitter::Tree, Vec<u8>) {
        let mut parser = Parser::new();
        parser
            .set_language(&crate::grammar::language())
            .expect("set_language");
        let bytes = src.as_bytes().to_vec();
        let tree = parser.parse(&bytes, None).expect("parse");
        (tree, bytes)
    }


    fn dump_node_stack(root: Node, byte: usize, src: &[u8], label: &str) {
        if let Some(mut node) = root.descendant_for_byte_range(byte, byte + 1) {
            let block_depth = super::block_depth_at(root, byte, src);
            let visual_depth = super::visual_block_depth_at(root, byte, src);
            eprintln!(
                "=== {label} at byte {byte} (block={block_depth}, visual={visual_depth}) ==="
            );
            loop {
                eprintln!(
                    "  kind={:<20} [{}..{}]",
                    node.kind(),
                    node.start_byte(),
                    node.end_byte()
                );
                if let Some(parent) = node.parent() {
                    node = parent;
                } else {
                    break;
                }
            }
        }
    }


    #[test]
    fn depth_outside_any_block_is_zero() {
        let src = "1 + 2;\n";
        let (tree, bytes) = parse_source(src);
        let root = tree.root_node();
        let byte = src.find('1').unwrap();
        assert_eq!(block_depth_at(root, byte, &bytes), 0);
    }


    #[test]
    fn depth_inside_simple_block_is_one() {
        let src = "x = {\n    1\n};\n";
        let (tree, bytes) = parse_source(src);
        let root = tree.root_node();
        let byte_one = src.find("\n    1").unwrap() + 5;
        assert_eq!(block_depth_at(root, byte_one, &bytes), 1);
    }


    #[test]
    fn depth_inside_nested_blocks_increases() {
        let src =
            r#" ( var a = 1; if (a > 0) { "level 1".postln; { "level 2".postln; }.value };) "#;
        let (tree, bytes) = parse_source(src);
        let root = tree.root_node();


        // top level parens -> depth 0
        let byte_if = src.find("if (a > 0)").unwrap();
        assert_eq!(
            block_depth_at(root, byte_if, &bytes),
            0,
            "if header should be at depth 0"
        );


        // inside first brace -> depth 1
        let byte_l1 = src.find(r#""level 1""#).unwrap();
        assert_eq!(block_depth_at(root, byte_l1, &bytes), 1);


        // inside second brace -> depth 2
        let byte_l2 = src.find(r#""level 2""#).unwrap();
        assert_eq!(block_depth_at(root, byte_l2, &bytes), 2);
    }


    #[test]
    fn depth_paren_wrapped_code_block_ignores_code_block() {
        let src = "( x = 1; { x }.value );";
        let (tree, bytes) = parse_source(src);
        let root = tree.root_node();


        // 'x' in "x = 1" -> top level parens ignored -> depth 0
        let byte_header_x = src.find("x = 1").unwrap();
        assert_eq!(block_depth_at(root, byte_header_x, &bytes), 0);


        // 'x' in "{ x }" -> function block -> depth 1
        let byte_block_x = src.find("{ x").unwrap() + 2;
        assert_eq!(block_depth_at(root, byte_block_x, &bytes), 1);
    }


    #[test]
    fn depth_inside_indexed_collection() {
        let src = "( var arr = [10, 20, 30]; arr[ 2 ];)";
        let (tree, bytes) = parse_source(src);
        let root = tree.root_node();


        // 2 is inside arr[...]. Outer parens ( ... ) are top-level -> 0.
        // indexed_collection -> 1.
        let byte_index = src.find("arr[ 2").map(|i| i + 5).unwrap();
        assert_eq!(block_depth_at(root, byte_index, &bytes), 1);
    }


    #[test]
    fn debug_section7_grouping_parens() {
        let src = r#"
(
// SECTION 7
(
    "this: is in a string",
    [1, 2, 3],
    (foo: "bar")
);
)
"#;
        let (tree, bytes) = parse_source(src);
        let root = tree.root_node();


        let byte_string = src.find("\"this: is in a string\"").unwrap();
        let byte_array = src.find("[1, 2, 3]").unwrap();
        let byte_event = src.find("(foo: \"bar\")").unwrap();


        // Debug: dump ancestry for [1, 2, 3]
        eprintln!("=== DEBUG section7 ===");
        eprintln!("byte_array = {}", byte_array);
        if let Some(mut node) = root.descendant_for_byte_range(byte_array, byte_array + 1) {
            eprintln!("Node ancestry for '[1, 2, 3]':");
            loop {
                eprintln!(
                    "  {} [{}-{}]",
                    node.kind(),
                    node.start_byte(),
                    node.end_byte()
                );
                if let Some(parent) = node.parent() {
                    node = parent;
                } else {
                    break;
                }
            }
        }


        let array_block = block_depth_at(root, byte_array, &bytes);
        let array_visual = visual_block_depth_at(root, byte_array, &bytes);
        eprintln!(
            "Array: block_depth={}, visual_depth={}",
            array_block, array_visual
        );


        // Outer ( ... ) ignored.
        // Inner ( ... ) is nested -> code_block -> depth 1.
        // Items inside are at depth 1.


        assert_eq!(
            visual_block_depth_at(root, byte_string, &bytes),
            1,
            "String depth"
        );
        assert_eq!(
            visual_block_depth_at(root, byte_array, &bytes),
            1,
            "Array depth"
        );
        assert_eq!(
            visual_block_depth_at(root, byte_event, &bytes),
            1,
            "Event depth"
        );
    }


    #[test]
    fn depth_pipe_param_function_block() {
        let src = "x = { |a=1, b=2| a + b };";
        let (tree, bytes) = parse_source(src);
        let root = tree.root_node();


        // a + b inside function block -> depth 1
        let byte_body = src.find("a + b").unwrap();
        assert_eq!(visual_block_depth_at(root, byte_body, &bytes), 1);
    }


    #[test]
    fn debug_exact_snapshot_case() {
        let src = r#"// pipe param missing commas – ORIGINAL


// no comma between foo and bar
x = { |foo = 3, bar = (4.dbamp)|
    foo + bar
};"#;


        let (tree, bytes) = parse_source(src);
        let root = tree.root_node();


        let first_foo = src.find("foo =").unwrap();
        let body_foo = src[first_foo + 1..]
            .find("foo")
            .map(|i| i + first_foo + 1)
            .unwrap();


        eprintln!("\n=== DEBUG SNAPSHOT CASE ===");
        dump_node_stack(root, body_foo, &bytes, "Body Foo");


        let v_depth = visual_block_depth_at(root, body_foo, &bytes);
        assert_eq!(v_depth, 1, "Should be indented depth 1");
    }


    #[test]
    fn debug_ast_indent_case_1() {
        let src = r#"// 1. Standard Block Nesting
(
    var a = 1;
    if (a > 0) {
        "level 1".postln;
    };
)"#;
        let (tree, bytes) = parse_source(src);
        let root = tree.root_node();


        // 'var' line
        let var_pos = src.find("var a").unwrap();
        eprintln!("\n=== INDENT CASE 1 DEBUG ===");
        dump_node_stack(root, var_pos, &bytes, "var a");


        let v = visual_block_depth_at(root, var_pos, &bytes);
        assert_eq!(v, 0, "Top level var should be depth 0");
    }


    #[test]
    fn debug_add_missing_commas_full() {
        // This mirrors fixtures/add_missing_commas/input.scd EXACTLY
        // 1. Outer parens (Code Block) -> Should be Depth 0
        // 2. x = { ... } (Function Block) -> Should be Depth 1
        let src = r#"(
// pipe param missing commas
x = { |foo = 3, bar = (4.dbamp)|
    foo + bar;
};
)"#;
        let (tree, bytes) = parse_source(src);
        let root = tree.root_node();


        // Find 'foo + bar' inside the function
        // It is the second 'foo' in the string
        let first_foo = src.find("foo =").unwrap();
        let body_pos = src[first_foo + 1..]
            .find("foo")
            .map(|i| i + first_foo + 1)
            .unwrap();


        eprintln!("\n=== DEBUG ADD MISSING COMMAS FULL ===");
        dump_node_stack(root, body_pos, &bytes, "foo + bar");


        // Check for ERROR nodes which would silently break indentation
        let has_error = root.has_error();
        eprintln!("Tree has error: {}", has_error);


        let v = visual_block_depth_at(root, body_pos, &bytes);
        eprintln!("Visual Depth: {}", v);


        // We expect Depth 1:
        // - SourceFile
        // - CodeBlock (Top Level) -> Ignored (+0)
        // - FunctionDefinition
        // - FunctionBlock -> Counted (+1)
        assert_eq!(
            v, 1,
            "Function body inside top-level parens should be Depth 1"
        );
    }


    #[test]
    fn debug_bang_operator_ast() {
        // Test to see how tree-sitter parses the ! operator with extra whitespace
        let src = "c = [10, 20]!  4;";
        let (tree, bytes) = parse_source(src);
        let root = tree.root_node();


        eprintln!("\n=== DEBUG BANG OPERATOR AST ===");
        eprintln!("Source: {}", src);
        eprintln!("Tree has error: {}", root.has_error());


        // Find the ! position
        let bang_pos = src.find('!').unwrap();
        eprintln!("Bang position: {}", bang_pos);


        // Dump the full tree
        fn dump_tree(node: Node, src: &[u8], indent: usize) {
            let text = if node.child_count() == 0 {
                let start = node.start_byte();
                let end = node.end_byte();
                if end <= src.len() {
                    format!(" {:?}", String::from_utf8_lossy(&src[start..end]))
                } else {
                    String::new()
                }
            } else {
                String::new()
            };


            eprintln!(
                "{:indent$}{} [{}-{}]{}",
                "",
                node.kind(),
                node.start_byte(),
                node.end_byte(),
                text,
                indent = indent
            );


            let mut cursor = node.walk();
            for child in node.children(&mut cursor) {
                dump_tree(child, src, indent + 2);
            }
        }


        dump_tree(root, &bytes, 0);


        // Check if there's a binary_expression containing !
        fn find_binary_with_bang(node: Node, src: &[u8]) -> bool {
            if node.kind() == "binary_expression" {
                let text = &src[node.start_byte()..node.end_byte()];
                if text.contains(&b'!') {
                    eprintln!("\nFound binary_expression with !:");
                    eprintln!("  Range: [{}-{}]", node.start_byte(), node.end_byte());
                    eprintln!("  Text: {:?}", String::from_utf8_lossy(text));


                    // Check for left/right fields
                    if let Some(left) = node.child_by_field_name("left") {
                        let lt = &src[left.start_byte()..left.end_byte()];
                        eprintln!("  Left: {} {:?}", left.kind(), String::from_utf8_lossy(lt));
                    } else {
                        eprintln!("  Left: NONE");
                    }
                    if let Some(right) = node.child_by_field_name("right") {
                        let rt = &src[right.start_byte()..right.end_byte()];
                        eprintln!(
                            "  Right: {} {:?}",
                            right.kind(),
                            String::from_utf8_lossy(rt)
                        );
                    } else {
                        eprintln!("  Right: NONE");
                    }
                    return true;
                }
            }


            let mut cursor = node.walk();
            for child in node.children(&mut cursor) {
                if find_binary_with_bang(child, src) {
                    return true;
                }
            }
            false
        }


        let found = find_binary_with_bang(root, &bytes);
        eprintln!("\nBinary expression with ! found: {}", found);


        // Also test with proper spacing
        let src2 = "c = [10, 20]!4;";
        let (tree2, bytes2) = parse_source(src2);
        let root2 = tree2.root_node();
        eprintln!("\n=== Comparison: properly spaced ===");
        eprintln!("Source: {}", src2);
        eprintln!("Tree has error: {}", root2.has_error());
        dump_tree(root2, &bytes2, 0);
        let found2 = find_binary_with_bang(root2, &bytes2);
        eprintln!("\nBinary expression with ! found: {}", found2);
    }


    #[test]
    fn debug_collection_ast_structure() {
        // Test various collection element types to understand AST structure
        let cases = [
            "[1, 2, 3]",
            "[\"foo\", \"bar\"]",
            "[\\a, \\b]",
            "[-1, -2]",
            "[3.14, 2.71]",
            "[a, b, c]",
            "[(1 + 2), (3 * 4)]",
            "[foo.bar, baz.qux]",
            "[[1, 2], [3, 4]]",
        ];


        for src in cases {
            eprintln!("\n=== COLLECTION: {} ===", src);
            let (tree, bytes) = parse_source(src);
            let root = tree.root_node();


            fn dump_tree(node: Node, src: &[u8], indent: usize) {
                let text = if node.child_count() == 0 {
                    let start = node.start_byte();
                    let end = node.end_byte();
                    if end <= src.len() {
                        format!(" {:?}", String::from_utf8_lossy(&src[start..end]))
                    } else {
                        String::new()
                    }
                } else {
                    String::new()
                };


                eprintln!(
                    "{:indent$}{} [{}-{}]{}",
                    "",
                    node.kind(),
                    node.start_byte(),
                    node.end_byte(),
                    text,
                    indent = indent
                );


                let mut cursor = node.walk();
                for child in node.children(&mut cursor) {
                    dump_tree(child, src, indent + 2);
                }
            }


            dump_tree(root, &bytes, 0);
        }
    }


    #[test]
    fn test_multiline_function_call_indent() {
        // This is the Pbind case - multi-line function call should indent its arguments
        let src = r#"e.stream = Pbind(
    \degree, Pseq([0, 1, 2], inf),
    \dur, 0.5
).asStream;"#;


        let (tree, bytes) = parse_source(src);
        let root = tree.root_node();


        eprintln!("\n=== MULTILINE FUNCTION CALL ===");
        eprintln!("Source:\n{}", src);
        eprintln!("Tree has error: {}", root.has_error());


        // Dump full tree
        fn dump_tree(node: Node, src: &[u8], indent: usize) {
            let text = if node.child_count() == 0 {
                let start = node.start_byte();
                let end = node.end_byte();
                if end <= src.len() {
                    format!(" {:?}", String::from_utf8_lossy(&src[start..end]))
                } else {
                    String::new()
                }
            } else {
                String::new()
            };


            eprintln!(
                "{:indent$}{} [{}-{}]{}",
                "",
                node.kind(),
                node.start_byte(),
                node.end_byte(),
                text,
                indent = indent
            );


            let mut cursor = node.walk();
            for child in node.children(&mut cursor) {
                dump_tree(child, src, indent + 2);
            }
        }


        dump_tree(root, &bytes, 0);


        // Find the \degree position
        let degree_pos = src.find("\\degree").unwrap();
        eprintln!("\n\\degree at byte {}", degree_pos);


        let v = visual_block_depth_at(root, degree_pos, &bytes);
        eprintln!("Visual depth at \\degree: {}", v);


        // The \degree line should be indented 1 level (inside Pbind's multi-line param list)
        assert_eq!(
            v, 1,
            "Arguments inside multi-line function call should be depth 1"
        );
    }
}

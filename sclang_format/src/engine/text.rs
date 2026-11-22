// src/engine/text.rs
//! What a byte is, said once. The rules used to carry a copy each.

/// A blank within a line. A rule that also counts a line break as space
/// (`pipe_param_commas`, `trailing_closures`) keeps its own.
#[must_use]
pub const fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

#[must_use]
pub const fn is_newline(b: u8) -> bool {
    b == b'\n' || b == b'\r'
}

/// Is the byte at `i` escaped, that is, preceded by an odd number of backslashes?
#[must_use]
pub const fn is_escaped(bytes: &[u8], i: usize) -> bool {
    let mut count = 0;
    let mut j = i;
    while j > 0 {
        j -= 1;
        if bytes[j] == b'\\' {
            count += 1;
        } else {
            break;
        }
    }
    count % 2 == 1
}

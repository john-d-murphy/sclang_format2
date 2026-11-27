//! Every line break is written `\n`, whatever the file has.
//!
//! A file from Windows ends its lines `\r\n`, one from the old Mac OS `\r`
//! alone. The formatter runs on Linux and writes `\n`: a carriage return is
//! read as the line break it stands for, before anything else is done. So a
//! file comes out the same whichever way its lines ended, and a second pass
//! changes nothing.

use sclang_format::format_source;

/// `src` with its line breaks as Unix has them.
fn unix(src: &str) -> String {
    src.replace("\r\n", "\n").replace('\r', "\n")
}

#[test]
fn a_file_comes_out_the_same_however_its_lines_end() {
    for src in [
        // The old Mac OS's, Windows's, and some of each.
        "{ a;\rb;\r}",
        "{\r\n    a;\r\n    b\r\n}\r\n",
        "{ a;\r\nb;\r}\n",
        // A line of regions, which is formatted region by region.
        "(\r\na = 1;\r\n)\r\n\r\n(\r\nb = 2;\r\n)\r\n",
    ] {
        let once = format_source(src).unwrap();
        assert!(!once.contains('\r'), "{src:?} came out as {once:?}");
        assert_eq!(once, format_source(&unix(src)).unwrap(), "of {src:?}");
        assert_eq!(format_source(&once).unwrap(), once, "a second pass of {src:?}");
    }
}

/// sclang ends a `//` comment at a carriage return, as at a line break: what
/// follows one is code, and stays code.
#[test]
fn a_comment_ends_at_a_carriage_return() {
    assert_eq!(format_source("// c\rx = 1;\r").unwrap(), "// c\nx = 1;\n");
}

/// A string written over several lines holds its line breaks, and they too
/// come out as `\n`: the one place where what the formatter writes compiles
/// to something else than what it read.
#[test]
fn a_line_break_inside_a_string_is_written_as_one() {
    assert_eq!(format_source("x = \"a\r\nb\"\r\n").unwrap(), "x = \"a\nb\"\n");
}

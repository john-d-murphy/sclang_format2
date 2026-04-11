for input_file in ./tests/fixtures/*/input.scd; do
    test_name="$(basename "$(dirname "$input_file")")"
    snap_file="./tests/snapshots/fixtures_insta__${test_name}__inline@out.snap"
    snap_new_file="./tests/snapshots/fixtures_insta__${test_name}__inline@out.snap.new"

    if ! [[ -f "$snap_file" ]] && ! [[ -f "$snap_new_file" ]]; then
        echo "$test_name"
    fi
done


for input_file in ./tests/sc_help/**/*.scd; do
    rel_path="${input_file#./tests/}"
    test_name="${rel_path//\//__}"
    test_name="${test_name%.scd}"

    snap_file="./tests/snapshots/fixtures_insta__${test_name}@out.snap"
    snap_new_file="${snap_file}.new"

    if ! [[ -f "$snap_file" ]] && ! [[ -f "$snap_new_file" ]]; then
         echo "$test_name"
    fi
done

#!/bin/bash
# Run this script to make every shell file is valid

THIS_FILE=$(readlink -f "${BASH_SOURCE[0]}")
THIS_DIR=$(dirname "${THIS_FILE}")

if [[ ! $(command -v shellcheck) ]]; then
    echo "Cannot find shellcheck"
    exit 1
fi

SHELLCHECK_RESULT="true"

function run_shellcheck() {
    local _this_file _this_dir
    while IFS= read -r -d '' shellfile; do
        _this_file=$(readlink -f "${shellfile}")
        _this_dir=$(dirname "${_this_file}")
        _this_file=$(basename "${_this_file}")
        if [[ ! -f "${_this_dir}/.shellcheck.disable" && ! -f "${_this_dir}/.${_this_file}.shellcheck.disable" ]]; then
            shellcheck "${shellfile}" || SHELLCHECK_RESULT="false"
        fi
    done < <(find "${1}" -type f -iname "*.sh" -print0)
}

if [[ $# -eq 0 ]]; then
    run_shellcheck "${THIS_DIR}"
else
    while (($#)); do
        target_dir=$(readlink -f "${1}")
        shift
        if [[ -d "${target_dir}" ]]; then
            run_shellcheck "${target_dir}"
        fi
    done
fi

[[ ${SHELLCHECK_RESULT} == true ]] || exit 1

#!/bin/bash
#
# Run this script to make every Dockerfile is valid

THIS_FILE=$(readlink -f "${BASH_SOURCE[0]}")
THIS_DIR=$(dirname "${THIS_FILE}")

if ! [[ $(command -v hadolint) && $(command -v shellcheck) ]]; then
    echo "Cannot find hadolint and shellcheck"
    exit 1
fi

HADOLINT_RESULT="true"

function run_hadolint() {
    local _this_file _this_dir
    while IFS= read -r -d '' dockerfile; do
        _this_file=$(readlink -f "${dockerfile}")
        _this_dir=$(dirname "${_this_file}")
        if [[ -f "${_this_dir}/.hadolint.yaml" ]]; then
            hadolint -c "${_this_dir}/.hadolint.yaml" "${dockerfile}" || HADOLINT_RESULT="false"
        else
            hadolint "${dockerfile}" || HADOLINT_RESULT="false"
        fi
    done < <(find "${1}" -type f -iname "Dockerfile*" -print0)
}

if [[ $# -eq 0 ]]; then
    run_hadolint "${THIS_DIR}"
else
    while (($#)); do
        target_dir=$(readlink -f "${1}")
        shift
        if [[ -d "${target_dir}" ]]; then
            run_hadolint "${target_dir}"
        fi
    done
fi

[[ ${HADOLINT_RESULT} == true ]] || exit 1

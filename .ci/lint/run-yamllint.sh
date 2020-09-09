#!/bin/bash
# Run this script to make every yaml file is valid

THIS_FILE=$(readlink -f "${BASH_SOURCE[0]}")
THIS_DIR=$(dirname "${THIS_FILE}")

[[ $(command -v yamllint) ]] || {
    echo "Cannot find yamllint"
    exit 1
}

YAMLLINT_RESULT="true"

function run_yamllint() {
    local _this_dir
    while IFS= read -r -d '' yamlfile; do
        _this_dir=$(dirname "${yamlfile}")
        YAMLINT_OPTS=""
        if [[ -f "${_this_dir}/.yamllint" ]]; then
            YAMLINT_OPTS="-c ${_this_dir}/.yamllint"
        elif [[ -f "${_this_dir}/.yamllint.yaml" ]]; then
            YAMLINT_OPTS="-c ${_this_dir}/.yamllint.yaml"
        elif [[ -f "${_this_dir}/.yamllint.yml" ]]; then
            YAMLINT_OPTS="-c ${_this_dir}/.yamllint.yal"
        fi
        #shellcheck disable=SC2086
        yamllint ${YAMLINT_OPTS} -s "${yamlfile}" || YAMLLINT_RESULT="false"
    done < <(find "${1}" -type f \( -iname "*.yml" -o -iname "*.yaml" \) -print0)
}

if [[ $# -eq 0 ]]; then
    run_yamllint "${THIS_DIR}"
else
    while (($#)); do
        target_dir=$(readlink -f "${1}")
        shift
        if [[ -d "${target_dir}" ]]; then
            run_yamllint "${target_dir}"
        fi
    done
fi

[[ ${YAMLLINT_RESULT} == true ]] || exit 1

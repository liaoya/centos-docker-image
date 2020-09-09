#!/bin/bash

set -e

THIS_FILE=$(readlink -f "${BASH_SOURCE[0]}")
THIS_DIR=$(dirname "${THIS_FILE}")
if [[ -n ${CI_PROJECT_DIR} ]]; then
    ROOT_DIR=${CI_PROJECT_DIR}
else
    ROOT_DIR=$(git rev-parse --show-toplevel)
fi

"${THIS_DIR}"/run-hadolint.sh "${ROOT_DIR}"
"${THIS_DIR}"/run-shellcheck.sh "${ROOT_DIR}"
"${THIS_DIR}"/run-yamllint.sh "${ROOT_DIR}"

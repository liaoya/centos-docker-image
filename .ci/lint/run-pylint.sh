#!/bin/bash

set -e

if [[ -n ${CI_PROJECT_DIR} ]]; then
    ROOT_DIR=${CI_PROJECT_DIR}
else
    ROOT_DIR=$(git rev-parse --show-toplevel)
fi

if [[ -x "${ROOT_DIR}"/.venv/bin/pylint ]]; then
    PYLINT=${ROOT_DIR}/.venv/bin/pylint
elif [[ $(command -v pylint) ]]; then
    PYLINT=$(command -v pylint)
else
    exit 1
fi

if [[ -f "${ROOT_DIR}/.pylintrc" ]]; then
    "${PYLINT}" --rcfile="${ROOT_DIR}/.pylintrc" "$@"
else
    "${PYLINT}" "$@"
fi

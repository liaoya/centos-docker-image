#!/bin/bash

_this_dir=$(readlink -f "${BASH_SOURCE[0]}")
_this_dir=$(dirname "${_this_dir}")
#shellcheck disable=SC1090
source "${_this_dir}/../.env"

if [[ ! -v TINYPROXY_VERSION ]]; then
    TINYPROXY_VERSION=$(curl -sL "${CURL_OPTS[@]}" https://api.github.com/repos/tinyproxy/tinyproxy/releases/latest | jq -r '.tag_name')
fi
TINYPROXY_VERSION=${TINYPROXY_VERSION:-1.10.0}
export TINYPROXY_VERSION
if [[ $(command -v add_image) ]]; then
    add_image "${IMAGE_PREFIX}/tinyproxy:${TINYPROXY_VERSION}"
fi

unset -v _this_dir

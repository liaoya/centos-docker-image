#!/bin/bash
#shellcheck disable=SC1090

set -ex

_this_dir=$(readlink -f "${BASH_SOURCE[0]}")
_this_dir=$(dirname "${_this_dir}")
source "${_this_dir}/../.env"

SQUID_VERSION=4.13
SQUID_IMAGE=${IMAGE_PREFIX}/squid:${SQUID_VERSION}
export SQUID_IMAGE SQUID_VERSION
if [[ $(command -v add_image) ]]; then
    add_image "${SQUID_IMAGE}"
fi

unset -v _this_dir

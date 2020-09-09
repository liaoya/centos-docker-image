#!/bin/bash

set -x

THIS_FILE=$(readlink -f "${BASH_SOURCE[0]}")

declare -a CURL_OPTS
if [[ -n ${GITHUB_API_TOKEN} ]]; then
    CURL_OPTS+=("-H" "Authorization: token ${GITHUB_API_TOKEN}")
fi

function install_busybox() {
    if [[ -z $(command -v busybox) ]]; then
        curl -sL https://busybox.net/downloads/binaries/1.30.0-i686/busybox -o /usr/local/bin/busybox
        chmod a+x /usr/local/bin/busybox
    fi
}

function install_docker_compose() {
    if [[ -z $(command -v docker-compose) ]]; then
        local DOCKER_COMPOSE_VERSION
        DOCKER_COMPOSE_VERSION=$(curl -sL "${CURL_OPTS[@]}" https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        curl -sL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        curl -sL "https://raw.githubusercontent.com/docker/compose/${DOCKER_COMPOSE_VERSION}/contrib/completion/bash/docker-compose" -o /etc/bash_completion.d/docker-compose
        chmod +x /usr/local/bin/docker-compose
        upx_command /usr/local/bin/docker-compose
    fi
}

function install_file() {
    if [[ ! $(command -v file) ]]; then
        if [[ $(command -v yum) ]]; then
            yum install -q -y file
        elif [[ $(command -v microdnf) ]]; then
            microdnf install file
        elif [[ $(command -v dnf) ]]; then
            dnf install -q -y file
        fi
    fi
}

function install_findutils() {
    if [[ ! $(command -v find) ]]; then
        if [[ $(command -v yum) ]]; then
            yum install -q -y findutils
        elif [[ $(command -v microdnf) ]]; then
            microdnf install findutils
        elif [[ $(command -v dnf) ]]; then
            dnf install -q -y findutils
        fi
    fi
}

function install_gettext() {
    if [[ -z $(command -v envsubst) ]]; then
        if [[ $(command -v yum) ]]; then
            yum install -q -y gettext
        elif [[ $(command -v microdnf) ]]; then
            microdnf install gettext
        elif [[ $(command -v dnf) ]]; then
            dnf install -q -y gettext
        fi
    fi
}

function install_hadolint() {
    if [[ -z $(command -v hadolint) ]]; then
        local HADOLINT_VERSION
        HADOLINT_VERSION=$(curl -sL "${CURL_OPTS[@]}" https://api.github.com/repos/hadolint/hadolint/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        HADOLINT_VERSION=${HADOLINT_VERSION:-v1.17.2}
        curl -sL "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64" -o /usr/local/bin/hadolint
        chmod a+x /usr/local/bin/hadolint
        upx_command /usr/local/bin/hadolint
    fi
}

function install_hostname() {
    if [[ ! $(command -v find) ]]; then
        if [[ $(command -v yum) ]]; then
            yum install -q -y hostname
        elif [[ $(command -v microdnf) ]]; then
            microdnf install hostname
        elif [[ $(command -v dnf) ]]; then
            dnf install -q -y hostname
        fi
    fi
}

function install_jq() {
    if [[ ! -x /usr/local/bin/jq ]]; then
        local JQ_VERSION
        JQ_VERSION=$(curl -sL "${CURL_OPTS[@]}" https://api.github.com/repos/stedolan/jq/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        JQ_VERSION=${JQ_VERSION:-jq-1.6}
        curl -sL "https://github.com/stedolan/jq/releases/download/${JQ_VERSION}/jq-linux64" -o /usr/local/bin/jq
        chmod a+x /usr/local/bin/jq
        if [[ $(command -v strip) ]]; then
            strip /usr/local/bin/jq
        fi
        upx_command /usr/local/bin/jq
    fi
}

function install_moreutils() {
    if [[ ! $(command -v sponge) ]]; then
        if [[ $(command -v yum) ]]; then
            yum install -q -y moreutils
        elif [[ $(command -v microdnf) ]]; then
            microdnf install moreutils
        elif [[ $(command -v dnf) ]]; then
            dnf --enablerepo epel --enablerepo ol8_codeready_builder -q -y install moreutils
        fi
    fi
}

function install_shellcheck() {
    if [[ -z $(command -v shellcheck) ]]; then
        local SHELLCHECK_VERSION
        if [[ $(uname -m) != "aarch64" && $(uname -m) != "x86_64" ]]; then
            echo "shellcheck does not support these platform"
            return 1
        fi
        SHELLCHECK_VERSION=$(curl -sL "${CURL_OPTS[@]}" https://api.github.com/repos/koalaman/shellcheck/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        curl -sLO "https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.linux.$(uname -m).tar.xz"
        tar -xf "shellcheck-${SHELLCHECK_VERSION}.linux.$(uname -m).tar.xz"
        chmod a+x "shellcheck-${SHELLCHECK_VERSION}/shellcheck"
        mv "shellcheck-${SHELLCHECK_VERSION}/shellcheck" /usr/local/bin
        rm -fr "shellcheck-${SHELLCHECK_VERSION}"*
        chown "$(id -u):$(id -g)" /usr/local/bin/shellcheck
        upx_command /usr/local/bin/shellcheck
    fi
}

function install_shfmt() {
    if [[ -z $(command -v shfmt) ]]; then
        local SHFMT_VERSION
        SHFMT_VERSION=$(curl -sL "${CURL_OPTS[@]}" https://api.github.com/repos/mvdan/sh/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        SHFMT_VERSION=${SHFMT_VERSION:-v3.1.0}
        curl -sL "https://github.com/mvdan/sh/releases/download/${SHFMT_VERSION}/shfmt_${SHFMT_VERSION}_linux_amd64" -o /usr/local/bin/shfmt
        chmod a+x /usr/local/bin/shfmt
        upx_command /usr/local/bin/shfmt
    fi
}

function install_tar() {
    if [[ ! $(command -v tar) ]]; then
        if [[ $(command -v yum) ]]; then
            yum install -q -y tar
        elif [[ $(command -v microdnf) ]]; then
            microdnf install tar
        elif [[ $(command -v dnf) ]]; then
            dnf -q -y install tar
        fi
    fi
}

function install_upx() {
    if [[ -z $(command -v upx) ]]; then
        local _dir _machine _url UPX_VERSION
        UPX_VERSION=$(curl -sL "${CURL_OPTS[@]}" https://api.github.com/repos/upx/upx/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        UPX_VERSION=${UPX_VERSION:-v3.96}
        _machine=$(uname -m)
        if [[ ${_machine} == "x86_64" ]]; then
            _url="https://github.com/upx/upx/releases/download/${UPX_VERSION}/upx-${UPX_VERSION:1}-amd64_linux.tar.xz"
        elif [[ ${_machine} == "x86_64" ]]; then
            _url="https://github.com/upx/upx/releases/download/${UPX_VERSION}/upx-${UPX_VERSION:1}-arm64_linux.tar.xz"
        fi
        curl -sL "${_url}" -o - | tar -I xz -xf -
        _dir=$(basename -s .tar.xz "${_url}")
        mv "${_dir}"/upx /usr/local/bin
        rm -fr "${_dir}"*
    fi
}

function install_yamllint() {
    if [[ ! $(command -v yamllint) ]]; then
        PIP_EXEC=$(find /usr/bin -type f -iname "pip*" | sort | tail -1)
        if [[ -z ${PIP_EXEC} ]]; then
            curl -sL https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
            PYTHON_EXEC=$(find /usr/bin -type f -iname "python*" | grep -v -e "m$" | grep -v '-' | tail -1)
            eval "${PYTHON_EXEC}" /tmp/get-pip.py
        fi
        PIP_EXEC=$(find /usr/bin -type f -iname "pip*" | sort | tail -1)
        eval "${PIP_EXEC}" install -q yamlint
    fi
}

function install_yq() {
    if [[ ! -x /usr/local/bin/yq ]]; then
        local YQ_VERSION
        YQ_VERSION=$(curl -sL "${CURL_OPTS[@]}" https://api.github.com/repos/mikefarah/yq/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        YQ_VERSION=${YQ_VERSION:-3.2.1}
        curl -sL "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o yq
        chmod a+x yq
        if [[ $(command -v strip) ]]; then strip yq; fi
        mv yq /usr/local/bin
        upx_command /usr/local/bin/yq
    fi
}

function upx_command() {
    local program
    program=$1
    shift
    if [[ $(command -v upx) ]]; then
        upx "${program}"
    fi
}

function install_all() {
    grep -e '^function install_[[:alnum:]]*' "${THIS_FILE}" | sed "s/() {//g" | sed "s/function //g" | grep -v "install_all" | sort | while IFS= read -r install_func; do
        "${install_func}"
    done
}

_CLEAN=0
if [[ $# -gt 0 && $1 == "-c" ]]; then
    _CLEAN=1
    shift
fi

while (($#)); do
    if [[ $(command -v "${1}") && ${_CLEAN} -gt 0 ]]; then
        #shellcheck disable=SC2086
        rm -f "$(command -v ${1})"
    fi
    name=${1//-/_}
    shift
    if grep -s -q -e "^function install_${name}()" "${THIS_FILE}"; then
        "install_${name}"
    else
        echo "Can't find 'install_${name}' in '${THIS_FILE}'"
    fi
done

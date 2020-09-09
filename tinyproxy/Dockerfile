FROM centos:centos8.2.2004 AS builder
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -ex && \
    dnf install -q -y gcc make tar xz && \
    dnf clean all && \
    rm -fr /var/cache/yum

ARG TINYPROXY_VERSION
# hadolint ignore=DL3003
RUN curl -sLO "https://github.com/tinyproxy/tinyproxy/releases/download/${TINYPROXY_VERSION}/tinyproxy-${TINYPROXY_VERSION}.tar.xz" && \
    tar -xf "tinyproxy-${TINYPROXY_VERSION}.tar.xz" && \
    cd "tinyproxy-${TINYPROXY_VERSION}" && \
    ./configure -q --prefix=/usr/local/tinyproxy && \
    make -s -j "$(nproc)" install-strip

FROM centos:centos8.2.2004
LABEL \
    maintainer liaoya@gmail.com \
    APP_NAME=tinyproxy
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -ex && \
    dnf install -q -y bind-utils jq less lsof nano procps-ng psmisc shadow-utils tar && \
    dnf clean all && \
    rm -fr /var/cache/yum

RUN set -ex && \
    groupadd tinyproxy && \
    useradd -d /home/tinyproxy -g tinyproxy -m -s /bin/bash tinyproxy

COPY --from=builder /usr/local/tinyproxy /usr/local/tinyproxy/

RUN set -ex && \
    mkdir -p /var/log/tinyproxy /run/tinyproxy /etc/tinyproxy && \
    chown -R "tinyproxy:tinyproxy" /etc/tinyproxy /run/tinyproxy /var/log/tinyproxy

USER tinyproxy
EXPOSE 8888
WORKDIR /home/tinyproxy
CMD ["/usr/local/tinyproxy/bin/tinyproxy", "-d", "-c", "/etc/tinyproxy/tinyproxy.conf"]

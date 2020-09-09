FROM centos:centos8.2.2004 AS builder
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -ex && \
    dnf install -q -y gcc make tar xz && \
    dnf clean all && \
    rm -fr /var/cache/yum

ARG TINYPROXY_VERSION
RUN curl -sLO "https://github.com/tinyproxy/tinyproxy/releases/download/${TINYPROXY_VERSION}/tinyproxy-${TINYPROXY_VERSION}.tar.xz" && \
    tar -xf "tinyproxy-${TINYPROXY_VERSION}.tar.xz" && \
    cd "tinyproxy-${TINYPROXY_VERSION}" && \
    ./configure -q && \
    make -s -j "$(nproc)" install-strip

FROM centos:centos8.2.2004
LABEL \
    maintainer tom.shen@oracle.com \
    APP_NAME=tinyproxy
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -ex && \
    dnf install -q -y bind-utils jq less lsof nano procps-ng psmisc shadow-utils tar && \
    dnf clean all && \
    rm -fr /var/cache/yum

RUN set -ex && \
    groupadd tinyproxy && \
    useradd -d /home/tinyproxy -g tinyproxy -m -s /bin/bash tinyproxy

RUN set -ex && \
    mkdir -p /usr/local/share/tinyproxy /usr/local/share/tinyproxy /usr/local/etc/tinyproxy /usr/local/share/man/man5 /usr/local/share/man/man8 /usr/local/share/doc/tinyproxy /var/log/tinyproxy /run/tinyproxy /etc/tinyproxy
COPY --from=builder /usr/local/bin/tinyproxy /usr/local/bin/
COPY --from=builder /usr/local/share/tinyproxy/*.html /usr/local/share/tinyproxy/
COPY --from=builder /usr/local/etc/tinyproxy/tinyproxy.conf /usr/local/etc/tinyproxy/
COPY --from=builder /usr/local/share/man/man5/* /usr/local/share/man/man5/
COPY --from=builder /usr/local/share/man/man8/* /usr/local/share/man/man8/
COPY --from=builder /usr/local/share/doc/tinyproxy/* /usr/local/share/doc/tinyproxy/
RUN chown -R "tinyproxy:tinyproxy" /etc/tinyproxy /run/tinyproxy /var/log/tinyproxy && \
    chmod +x /usr/local/bin/tinyproxy

USER tinyproxy
EXPOSE 8888
WORKDIR /etc/tinyproxy
CMD ["/usr/local/bin/tinyproxy", "-d"]

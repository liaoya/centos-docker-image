FROM centos:centos8.2.2004 AS builder
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -ex && \
    dnf install -q -y autoconf automake gcc gcc-c++ diffutils make perl sudo tar wget xz && \
    dnf clean all && \
    rm -fr /var/cache/yum

ARG SQUID_VERSION
# hadolint ignore=DL3003
RUN curl -sL "http://www.squid-cache.org/Versions/v${SQUID_VERSION:0:1}/squid-${SQUID_VERSION}.tar.xz" -o - | tar -I xz -xf - && \
    cd "squid-${SQUID_VERSION}" && \
    ./configure -q && \
    make -s -j "$(nproc)" install-strip

FROM centos:centos8.2.2004
LABEL \
    maintainer liaoya@gmail.com \
    APP_NAME=squid
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -ex && \
    dnf install -q -y bind-utils jq less lsof nano procps-ng psmisc shadow-utils tar && \
    dnf clean all && \
    rm -fr /var/cache/yum

COPY --from=builder /usr/local/squid /usr/local/squid/

RUN set -ex && \
    groupadd squid && \
    useradd -d /home/squid -g squid -m -s /bin/bash squid && \
    chown -R "squid:squid" /usr/local/squid/var

EXPOSE 3128
USER squid
WORKDIR /home/squid
CMD [ "/usr/local/squid/sbin/squid", "--foreground" ]

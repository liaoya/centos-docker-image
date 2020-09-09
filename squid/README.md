# README

Provide latest stable [squid](http://www.squid-cache.org), the offcial build is a little old.
This build only provide fundmetal function.
The packages (`libcom_err-devel krb5-devel libxml2-devel libcap-devel`) is require for more functions.

## Build

```bash
.ci/build-docker.sh -w squid

env SQUID_VERSION=4.13 .ci/build-docker.sh -w squid
```

## Testing

```bash
bash -c 'source squid/pre.sh; docker-compose -f squid/docker-compose.yaml up -d'
curl --proxy http://localhost:3128 -Lv https://httpbin.org/ip

bash -c 'source squid/pre.sh; docker-compose -f squid/docker-compose.yaml down -v'
```

If you have upstream proxy, add the following in squid.conf

```text
cache_peer <server> parent <port> 0 no-query no-digest
```

# Tinyproxy

Provide latest stable [tinyproxy](https://tinyproxy.github.io), the offcial build is a little old.

## Build

```bash
.ci/build-docker.sh -w tinyproxy
```

## Testing

```bash
bash -c 'source tinyproxy/pre.sh; docker-compose -f tinyproxy/docker-compose.yaml up -d'
curl --proxy http://localhost:8888 -Lv https://httpbin.org/ip

bash -c 'source tinyproxy/pre.sh; docker-compose -f tinyproxy/docker-compose.yaml down -v'
```

If you have upstream proxy, add the following in tinyproxy.conf

```text
Upstream http <server>:<port>
```

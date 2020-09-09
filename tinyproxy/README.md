# Tinyproxy

## Build

```bash
.ci/build-docker.sh -f tinyproxy/Dockerfile
```

## Testing

```bash
bash -c 'source tinyproxy/pre.sh; docker-compose -f tinyproxy/docker-compose.yaml up -d'
curl --proxy http://localhost:8888 -Lv https://httpbin.org/ip

bash -c 'source tinyproxy/pre.sh; docker-compose -f tinyproxy/docker-compose.yaml down -v'
```

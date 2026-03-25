---
title: 'Installation with Docker'
license: 'CC-BY-SA-4.0'
---

## OCI image

The [OCI images](https://code.forgejo.org/forgejo/-/packages/container/runner/) are built from the Dockerfile which is
[found in the source directory](https://code.forgejo.org/forgejo/runner/src/branch/main/Dockerfile). It contains the
`forgejo-runner` binary.

```shell
$ docker run --rm data.forgejo.org/forgejo/runner:12 forgejo-runner --version
forgejo-runner version v12.7.2
```

It does not run as root:

```shell
$ docker run --rm data.forgejo.org/forgejo/runner:12 id
uid=1000 gid=1000 groups=1000
```

## Docker Compose

One way to run the Docker image is via Docker Compose. To do so, as root, first prepare a `data` directory with non-root
permissions (in this case, we pick `1001:1001`):

```shell
#!/usr/bin/env bash

set -e

mkdir -p data/.cache

chown -R 1001:1001 data
chmod 775 data/.cache
chmod g+s data/.cache
```

After running this script with `bash setup.sh`, define the following `docker-compose.yml`:

```yaml
version: '3.8'

services:
  docker-in-docker:
    image: docker:dind
    container_name: 'docker_dind'
    privileged: 'true'
    command: ['dockerd', '-H', 'tcp://0.0.0.0:2375', '--tls=false']
    restart: 'unless-stopped'

  runner:
    image: 'data.forgejo.org/forgejo/runner:12'
    links:
      - docker-in-docker
    depends_on:
      docker-in-docker:
        condition: service_started
    container_name: 'runner'
    environment:
      DOCKER_HOST: tcp://docker-in-docker:2375
    # User without root privileges, but with access to `./data`.
    user: 1001:1001
    volumes:
      - ./data:/data
    restart: 'unless-stopped'
    command: 'forgejo-runner daemon --config config.yml'
```

Generate the default configuration file for `Forgejo Runner`, and store it in the `data` directory created previously:

```shell
$ docker run --rm data.forgejo.org/forgejo/runner:12 forgejo-runner generate-config > data/config.yml
```

`Forgejo Runner` needs to be configured and registered with Forgejo before it can be started successfully. [Configure
`Forgejo Runner`](../../configuration/#initial-configuration), editing `data/config.yml` file as you proceed.

Once the configuration is complete, you can start the runner by executing `docker compose up -d`.

More [docker compose](https://docs.docker.com/compose/) examples [are
provided](https://code.forgejo.org/forgejo/runner/src/branch/main/examples/docker-compose) to demonstrate how to install
the OCI image to successfully run a workflow.

---
title: 'Forgejo Runner Configuration'
license: 'CC-BY-SA-4.0'
---

## Choosing labels

When Forgejo identifies a job that needs to be run, it inspects the jobs' `runs-on` field to evaluate which `Forgejo
Runner` instances are capable of running the job. `runs-on` is typically a single value like `ubuntu-latest`, but in
more complex configurations it can also contain [multiple values](#special-labels).

When configuring a `Forgejo Runner`, labels must be defined in the configuration file which indicate what jobs this
runner should execute. For example:

```yaml
# ... the rest of the config file ...

runner:
  # ... other runner options ...
  labels:
    - ubuntu-22.04:docker://ghcr.io/catthehacker/ubuntu:act-22.04
    - ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-22.04
# ... the rest of the config file ...
```

This would cause a job with `runs-on: ubuntu-latest` to run on this `Forgejo Runner`, within the docker image
`ghcr.io/catthehacker/ubuntu:act-22.04`.

A label has the following structure:

```
<label-name>:<label-type>://<default-image>
```

The `label name` is a unique string that identifies the label. It is the part that is specified in the `runs-on` field
of workflows to choose which runners the workflow can be executed on.

The `label type` determines what containerization system will be used to run the workflow. There are three options:

1. `docker` for [Docker or Podman](#docker-or-podman) containerization,
2. `lxc` for [LXC](#lxc) containerization,
3. `host` for [no containerization](#host).

### Docker or Podman

If a label specifies `docker` as its `label type`, the rest of it is interpreted as the default container image to use.
The runner will execute all the steps, as root, within a container created from that image.

Label examples:

- `node20:docker://node:20-bookworm` defines `node20` to be the `node:20-bookworm` image from hub.docker.com.
- `node20:docker://docker.io/node:20-bookworm` would have the same behaviour, fully defining the host to fetch the image
  from.
- `docker:docker://data.forgejo.org/oci/alpine:3.20` defines `docker` to be the `alpine:3.20` image from
  https://data.forgejo.org/oci/-/packages/container/alpine/3.20.

To mimic GitHub runners, the a label such as `ubuntu-22.04:docker://node:20-bullseye` can be used. With this, the
Forgejo runner will respond to `runs-on: ubuntu-22.04` and will use the `node:20-bullseye` image from hub.docker.com.
This image is quite capable of running many of the workflows that are designed for the GitHub runners, but not all of
the same tools will be available as GitHub provides. A bigger image `ghcr.io/catthehacker/ubuntu:act-22.04` instead of
`node:20-bullseye` which should be compatible with most actions while remaining relatively small.

Many common actions (eg. `uses: actions/checkout@v6`) require Node.js in the image.

The container image specified in the label can be overridden by a workflow by using
[`jobs.<job_id>.container`](../../../user/actions/reference/#jobsjob_idcontainerimage).

### LXC

If a label specifies `lxc` as its `label type`, the rest of it is interpreted as `template[:release[:lxc-helper
config]]` where:

- `template[:release]` is the [template and release](https://images.linuxcontainers.org/) to use.
- `lxc-helper config` is the value of the [--config option of lxc-helper](https://code.forgejo.org/forgejo/lxc-helpers/)
  used when creating a container.

The runner will execute all the steps, as root, within a [LXC container](https://linuxcontainers.org/) created from that
template and release. The default template is `debian` and the default release is `bullseye`.

[nodejs](https://nodejs.org/en/download/) version 20 is installed.

Label examples:

- `bookworm:lxc://debian:bookworm:lxc docker` defines `bookworm` to be an LXC container running Debian GNU/Linux
  bookworm. It has the necessary capabilities to run a nested LXC container and a Docker engine.
- `bookworm:lxc://debian:bookworm` defines `bookworm` to be an LXC container running Debian GNU/Linux bookworm. It has
  the necessary capabilities to run a nested LXC container, KVM virtual machines and a Docker engine.

### Host

If a label specifies `host` as its `label type`, the runner will execute all the steps in a shell forked from the
runner, directly on the host.

> **Warning:** There is no isolation at all and a single job can permanently destroy the host.

Label example:

- `self-hosted:host` defines jobs that have `runs-on: self-hosted` to run without any container isolation.

### Special labels

Runner labels can also be used to define other special features a runner has.

For example, if three runners were available for executing jobs and all of them defined the
`docker::docker://node:20-bookworm` label, then jobs would be distributed between each of the three runners as they are
available. If only a single one of these runners had a special hardware capability like a GPU, there may be jobs that
require that capability and can't be run on the other systems.

The solution in this case is to add multiple labels to a job's `runs-on` field:

```yaml
on: pull_request
jobs:
  my-job:
    runs-on: [docker, gpu]
    # ...
```

And then to specify both the `docker:...` and `gpu:...` labels in the `Forgejo Runner` configuration:

```yaml
runner:
  labels:
    - docker:docker://ghcr.io/catthehacker/ubuntu:act-22.04
    - gpu:docker://ghcr.io/catthehacker/ubuntu:act-22.04
```

Only a `Forgejo Runner` with **both** the `docker` and `gpu` labels will be able to run the job. The job will be run on
the containerization platform that is listed in the first label in the `runs-on` array.

## Enabling IPv6 in Docker & Podman networks

When a `Forgejo runner` creates its own Docker or Podman networks, IPv6 is not enabled by default, and must be enabled
explicitly in the `Forgejo runner` configuration.

**Docker only**: The Docker daemon requires additional configuration to enable IPv6. To make use of IPv6 with Docker,
you need to provide a `/etc/docker/daemon.json` configuration file with at least the following keys:

```json
{
  "ipv6": true,
  "experimental": true,
  "ip6tables": true,
  "fixed-cidr-v6": "fd00:d0ca:1::/64",
  "default-address-pools": [
    { "base": "172.17.0.0/16", "size": 24 },
    { "base": "fd00:d0ca:2::/104", "size": 112 }
  ]
}
```

Afterwards restart the Docker daemon with `systemctl restart docker.service`.

> **NOTE**: These are example values. While this setup should work out of the box, it may not meet your requirements.
> Please refer to the Docker documentation regarding [enabling
> IPv6](https://docs.docker.com/config/daemon/ipv6/#use-ipv6-for-the-default-bridge-network) and [allocating IPv6
> addresses to subnets dynamically](https://docs.docker.com/config/daemon/ipv6/#dynamic-ipv6-subnet-allocation).

**Docker & Podman**: To test IPv6 connectivity in `Forgejo runner`-created networks, create a small workflow such as the
following:

```yaml
---
on: push
jobs:
  ipv6:
    runs-on: docker
    steps:
      - run: |
          apt update; apt install --yes curl
          curl -s -o /dev/null http://ipv6.google.com
```

If you run this action with `forgejo-runner exec`, you should expect this job fail:

```shellsession
$ forgejo-runner exec
...
| curl: (7) Couldn't connect to server
[ipv6.yml/ipv6]   ❌  Failure - apt update; apt install --yes curl
curl -s -o /dev/null http://ipv6.google.com
[ipv6.yml/ipv6] exitcode '7': failure
[ipv6.yml/ipv6] Cleaning up services for job ipv6
[ipv6.yml/ipv6] Cleaning up container for job ipv6
[ipv6.yml/ipv6] Cleaning up network for job ipv6, and network name is: FORGEJO-ACTIONS-TASK-push_WORKFLOW-ipv6-yml_JOB-ipv6-network
[ipv6.yml/ipv6] 🏁  Job failed
```

To actually enable IPv6 with `forgejo-runner exec`, the flag `--enable-ipv6` must be provided. If you run this again
with `forgejo-runner exec --enable-ipv6`, the job should succeed:

```shellsession
$ forgejo-runner exec --enable-ipv6
...
[ipv6.yml/ipv6]   ✅  Success - Main apt update; apt install --yes curl
curl -s -o /dev/null http://ipv6.google.com
[ipv6.yml/ipv6] Cleaning up services for job ipv6
[ipv6.yml/ipv6] Cleaning up container for job ipv6
[ipv6.yml/ipv6] Cleaning up network for job ipv6, and network name is: FORGEJO-ACTIONS-TASK-push_WORKFLOW-ipv6-yml_JOB-ipv6-network
[ipv6.yml/ipv6] 🏁  Job succeeded
```

Finally, if this test was successful, enable IPv6 in the `config.yml` file of the `Forgejo runner` daemon and restart
the daemon:

```yaml
container:
  enable_ipv6: true
```

Now, `Forgejo runner` will create networks with IPv6 enabled, and workflow containers will be assigned addresses from
the pools defined in the Docker daemon configuration.

### IPv6 connectivity issues with rootless podman

Because creation of real networks is limited to the root user, rootless podman cannot create actual networks. To work
around this issue, podman creates so-called tap-networks which come with [their own
limitations](https://github.com/containers/podman/blob/main/rootless.md). At the time of writing, only Podman version
5.3 and later have been observed to have proper IPv6 support in rootless bridge networks. Podman 5 switched to
[`passt`](https://passt.top/passt/about/) for rootless networking and 5.3 includes fixes like host-service reachability.
(Earlier versions appear to cause "host unreachable" or "network unreachable" issues with bridge networks - which is the
type Forgejo runners create.)

## Cache configuration

Some actions such as `https://data.forgejo.org/actions/cache` or `https://data.forgejo.org/actions/setup-go` can
communicate with the `Forgejo runner` to save and restore commonly used files such as compilation dependencies. They are
stored as compressed tar archives, fetched when a job starts and saved when it completes.

If the machine has a fast disk, uploading the cache when the job starts may significantly reduce the bandwidth required
to download and rebuild dependencies.

For more information see the `cache` section of the [runner configuration file](#configuration).

## Configuration file reference

Installation procedures for `Forgejo Runner` describe how to generate a default configuration file, eg. [for a binary
installation](../installation/binary/#configuration) or [for a docker compose
installation](../installation/docker/#configuration). Those procedures are recommended to ensure the correct
configuration file format is provided, with all the available options that match the version of `Forgejo Runner` that
you are installing.

All `Forgejo Runner` configuration options are documented in the default configuration file in YAML comments.

The most recent version of the configuration file can be viewed [in the forgejo/runner
repo](https://code.forgejo.org/forgejo/runner/src/branch/main/internal/pkg/config/config.example.yaml).

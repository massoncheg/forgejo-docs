---
title: 'Installation from binary'
license: 'CC-BY-SA-4.0'
---

## System requirements

`Forgejo Runner` requires that Git is installed, and has been tested with a minimum version of Git 2.24.3.

## Downloading and installing the binary

Download the latest [binary release](https://code.forgejo.org/forgejo/runner/releases) and verify its signature:

```shell
$ export ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
$ export RUNNER_VERSION=$(curl -X 'GET' https://data.forgejo.org/api/v1/repos/forgejo/runner/releases/latest | jq .name -r | cut -c 2-)
$ export FORGEJO_URL="https://code.forgejo.org/forgejo/runner/releases/download/v${RUNNER_VERSION}/forgejo-runner-${RUNNER_VERSION}-linux-${ARCH}"
$ wget -O forgejo-runner ${FORGEJO_URL} || curl -o forgejo-runner ${FORGEJO_URL}
$ chmod +x forgejo-runner
$ wget -O forgejo-runner.asc ${FORGEJO_URL}.asc || curl -o forgejo-runner.asc ${FORGEJO_URL}.asc
$ gpg --keyserver hkps://keys.openpgp.org --recv EB114F5E6C0DC2BCDD183550A4B61A2DC5923710
$ gpg --verify forgejo-runner.asc forgejo-runner && echo "✓ Verified" || echo "✗ Failed"
Good signature from "Forgejo <contact@forgejo.org>"
        aka "Forgejo Releases <release@forgejo.org>"
✓ Verified
```

Next, copy the downloaded binary to `/usr/local/bin` and make it executable:

```shell
$ cp forgejo-runner /usr/local/bin/forgejo-runner
```

You should now be able to test the runner by running `forgejo-runner -v`:

```
$ forgejo-runner -v
forgejo-runner version v12.7.3
```

## Setting up the runner user

Set up the user to run the daemon:

```shell
$ useradd --create-home runner
```

If the runner will be using Docker (or rootful Podman through the Docker shim), ensure the `runner` user has access to
the docker/podman socket. If you are using Docker, run the following command to grant access to the docker socket:

```shell
$ usermod -aG docker runner
```

## Setting up the container environment

The `Forgejo Runner` relies on application containers (Docker, Podman, etc.) or system containers (LXC) to execute a
workflow in an isolated environment. They need to be installed and configured independently.

It is common for workflows to also require interaction with a container environment, for example to execute `docker
build` commands. This is distinct from how Forgejo Runner itself executes jobs, and is an optional configuration that is
described in detail in [Utilizing Docker within Actions](../../docker-access/).

### Docker

See the [Docker installation](https://docs.docker.com/engine/install/) documentation for more information.

### Podman

Podman provides a (generally compatible) Docker CLI and Socket. Depending on your distribution, you may need to install
an additional package (e.g. `podman-docker` for Ubuntu). The socket is _not enabled by default_ and must be enabled. If
it is not, the Forgejo runner complains about "daemon Docker Engine socket not found", or "cannot ping the docker
daemon". On systemd-based distributions, there is a systemd unit available which can be enabled `systemctl enable --now
podman.socket`. To use [rootless
podman](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md) for the socket, run
`systemctl --user enable --now podman.socket` as the runner user.

On non-systemd distributions, the podman socket can be provided by running `podman system service -t 0` in the
background.

The location of the podman socket must be passed to the Forgejo runner using the `DOCKER_HOST` environment variable.

```shell
$ DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/podman/podman.sock ./forgejo-runner daemon
```

### LXC

For jobs to run in LXC containers, the `Forgejo Runner` needs passwordless sudo access for all `lxc-*` commands on a
Debian GNU/Linux `bookworm` system where [LXC](https://linuxcontainers.org/lxc/) is installed. The [LXC
helpers](https://code.forgejo.org/forgejo/lxc-helpers/) can be used as follows to create a suitable container:

```shell
$ git clone https://code.forgejo.org/forgejo/lxc-helpers
$ sudo cp -a lxc-helpers/lxc-helpers{,-lib}.sh /usr/local/bin
$ lxc-helpers.sh lxc_container_create myrunner
$ lxc-helpers.sh lxc_container_start myrunner
$ lxc-helpers.sh lxc_container_user_install myrunner 1000 debian
```

> **NOTE:** Multiarch [Go](https://go.dev/) builds and [binfmt](https://github.com/tonistiigi/binfmt) need `bookworm` to
> produce and test binaries on a single machine for people who do not have access to dedicated hardware.

The `Forgejo Runner` can then be installed and run within the `myrunner` container.

```shell
$ lxc-helpers.sh lxc_container_run forgejo-runners -- sudo --user debian bash
$ sudo apt-get install docker.io wget gnupg2
$ wget -O forgejo-runner https://code.forgejo.org/forgejo/runner/releases/download/v12.7.3/forgejo-runner-12.7.3-linux-amd64
...
```

> **Warning:** LXC containers do not provide a level of security that makes them safe for potentially malicious users to
> run jobs. They provide an excellent isolation for jobs that may accidentally damage the system they run on.

### Host

There are no requirements for jobs that run directly on the host.

> **Warning:** there is no isolation at all and a single job can permanently destroy the host.

> **Warning:** processes forked out of a job may linger after the job is complete, possibly forever, if the job fails to
> wait for them to complete.

## Configuration

Generate the default configuration file for `Forgejo Runner`, and store it in a `/home/runner`:

```shell
$ forgejo-runner generate-config > /home/runner/runner-config.yml
```

`Forgejo Runner` needs to be configured and registered with Forgejo before it can be started successfully. [Configure
`Forgejo Runner`](../../configuration/#initial-configuration), editing `/home/runner/runner-config.yml` file as you
proceed.

> **NOTE**: `Forgejo Runner` requires the configuration file to be explicitly specified with the `-c` command-line
> option. There is no default configuration file location.

## Starting the runner

After the runner has been registered, it can be started by running `forgejo-runner daemon` as the `runner` user, in the
home directory:

```shell
$ whoami
runner
$ pwd
/home/runner
$ forgejo-runner daemon -c runner-config.yml
INFO[2024-09-14T19:19:14+02:00] Starting runner daemon
```

## Running as a systemd service

To automatically start the runner when the system starts, copy
[forgejo-runner.service](https://code.forgejo.org/forgejo/runner/src/branch/main/contrib/forgejo-runner.service) to
`/etc/systemd/system/forgejo-runner.service`.

Then run `systemctl daemon-reload` to reload the unit files. Run `systemctl start forgejo-runner.service` to test the
new service. If everything works, run `systemctl enable forgejo-runner.service` to enable auto-starting the service on
boot.

Use `journalctl -u forgejo-runner.service` to read the runner logs.

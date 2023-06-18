---
layout: '~/layouts/Markdown.astro'
title: Hardware infrastructure
license: 'CC-BY-SA-4.0'
---

## Codeberg

Codeberg provides a LXC container with 48GB RAM, 24 threads and SSD drive to be used for the CI. A Forgejo Runner is installed in `/opt/runner` and registered with a token obtained from https://codeberg.org/forgejo. It does not allow running privileged containers or LXC containers for security reasons. The runner is intended to be used for pull requests, for instance in https://codeberg.org/forgejo/forgejo.

## Octopuce

[Octopuce provides hardware](https://codeberg.org/forgejo/sustainability) managed by [the devops team](https://codeberg.org/forgejo/governance/src/branch/main/TEAMS.md#devops). It can be accessed via a VPN which provides a DNS for the `octopuce.forgejo.org` internal domain.

The VPN is deployed and upgraded using the following [Enough command line](https://enough-community.readthedocs.io):

```shell
$ mkdir -p ~/.enough
$ git clone https://forgejo.octopuce.forgejo.org/forgejo/enough ~/.enough/octopuce.forgejo.org
$ enough --domain octopuce.forgejo.org service create openvpn
```

## OVH

https://code.forgejo.org runs on an OVH virtual machine using the same
OVH account used for the forgejo.org domain name and mails.

It is deployed and upgraded using the following [Enough command line](https://enough-community.readthedocs.io):

```shell
$ mkdir -p ~/.enough
$ git clone https://code.forgejo.org/forgejo/<secret repository> ~/.enough/code.forgejo.org
$ enough --domain code.forgejo.org service create --host bind-host forgejo
```

Upgrading only Forgejo:

```shell
$ enough --domain code.forgejo.org playbook -- --limit bind-host,localhost --private-key ~/.enough/code.forgejo.org/infrastructure_key venv/share/enough/playbooks/forgejo/forgejo-playbook.yml
```

Login in the machine hosting the Forgejo instance for debugging purposes:

```shell
enough --domain code.forgejo.org ssh bind-host
```

## Installing Forgejo runners

### Preparing the LXC hypervisor

```shell
git clone https://code.forgejo.org/forgejo/lxc-helpers/

lxc-helpers.sh lxc_container_create forgejo-integration-runner
lxc-helpers.sh lxc_container_start forgejo-integration-runner
lxc-helpers.sh lxc_container_user_install forgejo-integration-runner $(id -u) $USER
```

### Creating an LXC container

```shell
lxc-helpers.sh lxc_container_run forgejo-integration-runner -- sudo --user debian bash
sudo apt-get update
sudo apt-get install wget docker.io emacs-nox
sudo usermod -aG docker $USER
lxc-helpers.sh lxc_prepare_environment
wget -O forgejo-runner https://code.forgejo.org/forgejo/runner/releases/download/v2.0.4/forgejo-runner-amd64
chmod +x forgejo-runner
```

### Creating a runner

```shell
URL=codeberg.org/forgejo-integration
PATH=$(pwd):$PATH
mkdir -p $URL ; cd $URL
forgejo-runner generate-config > config.yml
## edit config.yml
## obtain a token for $URL
forgejo-runner register --no-interactive --token XXXXXXX --name runner --instance https://codeberg.org --labels docker:docker://node:16-bullseye,self-hosted
forgejo-runner --config config.yml daemon | cat -v | tee runner.log
```

#### codeberg.org config.yml

- `fetch_timeout: 30s` # because it can be slow at times
- `fetch_interval: 60s` # because there is throttling and 429 replies will mess up the runner

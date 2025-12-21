---
title: Instance Commit Signing
license: 'CC-BY-SA-4.0'
---

Forgejo has the ability to sign commits when Forgejo themselves generates those commits, such as:

- Repository initialisation
- Wiki changes
- CRUD actions using the web editor or the API
- Merges from pull requests

## Configuration

In order for Forgejo to sign commits, it has to know how it should be signing commits and when to sign commits.
Unless otherwise indicated, all configuration settings discussed on this page are for the `[repository.signing]` section.

### Signing key

Forgejo offers two formats to sign commits with: GPG and SSH.
If you meet the requirements of SSH, then it is strongly preferred to use that instead of GPG.

#### SSH

For Forgejo to do SSH commit signing, it needs a Git version equal to or newer than 2.34.0 and `ssh-keygen` binary equal to or newer than version 8.2p1.[^1]

[^1]: The git version check is already done by Forgejo, but for `ssh-keygen` only the presence of the binary is checked.

You need a dedicated OpenSSH key pair for instance signing.
If you don't have such key pair yet you can generate one via `ssh-keygen`[^2] or you also could store the SSH key in TPM, there is [a dedicated section](#using-ssh-tpm-agent) with instructions on how to do that.

[^2]: https://docs.codeberg.org/security/ssh-key/ contains instructions for generating an SSH key pair, you should not generate a FIDO2 (`-sk` type) key pair as that will not work with Forgejo.

Forgejo needs to be told that it should use SSH signing and which SSH key to use, this should be configured as followed:

```ini
FORMAT = ssh
SIGNING_KEY = /absolute/path/to/public/ssh/key.pub
```

The value for the `SIGNING_KEY` setting needs to be an absolute path to the public key, where the private key needs to be available in the path without the `.pub` suffix.

Forgejo also needs to be told who the committer of the commit is, which requires a name and email and should be configured as followed:

```ini
SIGNING_NAME = "forgejo.org Instance"
SIGNING_EMAIL = "noreply@forgejo.org"
```

#### GPG

There are two ways to tell Forgejo which GPG key should be used for commit signing.

```ini
SIGNING_KEY = default
```

Will use the git config to determine the signing key: if the value of `commit.gpgsign` is set to true, then it will use the values of `user.signingkey`, `user.name` and `user.email` for the signing key, committer name and committer email respectively.

---

```ini
SIGNING_KEY = GPG-KEY-ID
SIGNING_NAME = "forgejo.org Instance"
SIGNING_EMAIL = "noreply@forgejo.org"
```

Will use the GPG keyid to search for the key in the GPG keyring. Forgejo searches for this key in a directory, which can be computed as follows: If a `GNUPGHOME` environment variable is set, this is used.
Otherwise the `.gnupg` directory in the directory corresponding to the value of the `HOME_PATH` setting in the `[git]` section is used (`[git].HOME_PATH/.gnupg` so to say).
It should be noted that by default, GPG does not use that keyring and you should take extra care when importing or generating the key, for example by setting the value of the `GNUPGHOME` environment to the directory Forgejo uses.

### Signing operations

There are several operations for which Forgejo will generate a commit and thus be able to sign the commit.
For each operation you can specify under which conditions Forgejo should sign the commit.

For each operation, you can combine the values as a comma-separated list.
There are two special values that are valid values for each operation and cannot be combined with any other value for that operation: `always` and `never`.
The first value, if set, will always sign the commit and the second value, if set, will never sign the commit.

#### Initial commit

When should Forgejo sign the initial commit when creating a repository.
The possible values for the `INITIAL_COMMIT` setting are:

- `pubkey`: Only if the user has added a GPG or SSH key to its account.
- `twofa`: Only if the user is enrolled into two-factor authentication.

#### Wiki

When should Forgejo sign commits to the wiki.
The possible values for the `WIKI` setting are:

- `pubkey`: Only if the user has added a GPG or SSH key to its account.
- `twofa`: Only if the user is enrolled into two-factor authentication.
- `parentsigned`: Only if the parent commit is signed.

#### CRUD actions

When should Forgejo sign commits that are created for file changes via the web editor or API.
The possible values for the `CRUD_ACTIONS` setting are:

- `pubkey`: Only if the user has added a GPG or SSH key to its account.
- `twofa`: Only if the user is enrolled into two-factor authentication.
- `parentsigned`: Only if the parent commit is signed.

#### Pull request merges

When should Forgejo sign merge commits from pull requests.
The possible values for the `MERGES` setting are:

- `pubkey`: Only if the user has added a GPG or SSH key to its account.
- `twofa`: Only if the user is enrolled into two-factor authentication.
- `basesigned`: Only if the parent commit in the base repository is signed.
- `headsigned`: Only if the head commit in the head branch is signed.
- `commitssigned`: Only if all the commits in the head branch to the merge point are signed.
- `approved`: Only if the pull request targets a protected branch and has at least one approval.

## Obtaining the instance signing key

If a GPG instance signing key is set, the GPG public key can be obtained at the API route, `/api/v1/signing-key.gpg`.
If a repository specific GPG key is set, it can be obtained at the API route, `/api/v1/repos/{username}/{reponame}/signing-key.gpg`

If a SSH instance signing key is set, the SSH public key can be obtained at the API route, `/api/v1/signing-key.ssh`.

## Using ssh-tpm-agent

It is possible to use [ssh-tpm-agent](https://github.com/Foxboron/ssh-tpm-agent) so that the SSH private key can only be used in combination with a [Trusted Platform Module (TPM)](https://en.wikipedia.org/wiki/Trusted_Platform_Module). To use this, the server that Forgejo runs on must have access to TPM 2.0.
This section only explains how to make the SSH private key available to Forgejo, not how to configure Forgejo to use it.

Follow [the instruction from ssh-tpm-agent](https://github.com/Foxboron/ssh-tpm-agent#usage) to create a key or import an existing key.
An instance key is expected to be a long-lived key[^3] and therefore it is advisable to follow the 'Import existing key' guide as it allows you to backup the private key in a safe place and in case of a recovery, restore the instance SSH key.

[^3]: Rotating instance keys is currently not possible.

ssh-tpm-agent acts as an [`ssh-agent(1)`](https://man.archlinux.org/man/ssh-agent.1) and in order for Forgejo to use ssh-tpm-agent to sign commits with, it needs to have a `SSH_AUTH_SOCK` environment set when launching the Forgejo binary.
How to pass this to Forgejo depends on how you run Forgejo, we consider two situation: a Systemd service on bare-metal or containerized (for example, via Docker).

In either case, the host will need to install the systemd unit service by running `ssh-tpm-agent --install-user-units`.

### Systemd service

In the `[Service]` section, add the following (it is fine to have multiple `Environment` keys):

```toml
Environment=SSH_AUTH_SOCK="/socket/path"
```

Where `/socket/path` is replaced with the value of `ssh-tpm-agent --print-socket`.

### Containerized

We take [the default docker-compose file](../../installation/docker/#docker) as an example.
We add an environment variable and a volume mount to the compose file:

```yaml
networks:
  forgejo:
    external: false

services:
  server:
    image: codeberg.org/forgejo/forgejo:10
    container_name: forgejo
    environment:
      - USER_UID=1000
      - USER_GID=1000
+      - SSH_AUTH_SOCK=$SOCKET_PATH
    restart: always
    networks:
      - forgejo
    volumes:
      - ./forgejo:/data
      - /etc/localtime:/etc/localtime:ro
+      - $SOCKET_PATH:$SOCKET_PATH
    ports:
      - "3000:3000"
      - "222:22"
```

Where `$SOCKET_PATH` is to be replaced with the value of `ssh-tpm-agent --print-socket`.
Another volume would need to be added that exposes the public OpenSSH key, the container path should match with the path that is specified for the `SIGNING_KEY` setting.

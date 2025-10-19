---
title: Release management
license: 'CC-BY-SA-4.0'
---

## Release cycle

See [the release schedule](../../admin/release-schedule).

### Stable release support

Bug fixes and security fixes are backported to the latest stable release.

### Long Term Support (LTS)

The first quarter release of the year is LTS. Critical bug fixes and security fixes are backported to the latest LTS release.

### Experimental releases

Experimental releases are published daily in [forgejo-experimental](https://codeberg.org/forgejo-experimental/) organization. They are built from the tip of the branch of each stable release. For instance:

- `forgejo` is `X.Y-test` where `X.Y` is the major and minor number of the next stable release.
- `v8.0/forgejo` is `8.0-test`
- `v7.0/forgejo` is `7.0-test`

## Release numbering

The Forgejo release numbers are compliant with [Semantic Versioning](https://semver.org/). They are followed by the Gitea release number with which they compatible. For instance:

- Forgejo **v7.0.5+gitea-1.21.0** is compatible with Gitea **v1.21.0**.

The release candidates are built of the stable branch and published with the **-test** suffix:

- Forgejo **v7.0-test**
- Forgejo **v8.0-test**
- Forgejo **v8.1-test**
- etc.

## Stable release management

Major and patch releases are published with the help of the [release-manager](https://code.forgejo.org/forgejo/release-manager).

## LTS toolchain upgrades

The Forgejo toolchain relies on Go OCI images based on
Alpine. Only the [last two Alpine versions are
supported](https://github.com/docker-library/golang/commit/cf7a37dedf1fd5a25ca72075645368d1e3c30c4a)
and will be EOL before the Forgejo LTS. In order to receive security
updates the toolchain needs to be upgraded to a supported Alpine and
Go version because it goes EOL.

## Automated experimental releases

The Forgejo development and stable branches are [pushed daily to the
forgejo-integration](https://codeberg.org/forgejo/forgejo/src/branch/forgejo/.forgejo/workflows/mirror.yml).
It triggers the [release build
workflow](https://codeberg.org/forgejo/forgejo/src/branch/forgejo/.forgejo/workflows/build-release.yml)
which creates a new release for each updated branch, based on their latest commit:

- the `forgejo` branch creates the `X.Y-test` release where `X.Y` is based on the most recent tag. For instance:
  - the tag `v8.0.0-dev` will create the `8.0-test` release
  - the tag `v8.1.0-dev` will create the `8.1-test` release
- the `v*/forgejo` branches create `X.Y-test` releases where `X.Y` is based on their name. For instance:
  - the branch `v7.0/forgejo` will create the `7.0-test` release
  - the branch `v7.1/forgejo` will create the `7.1-test` release

## Forgejo release mirror

The https://code.forgejo.org/forgejo/forgejo repository is a read-only
mirror [updated daily](https://code.forgejo.org/forgejo/forgejo/src/branch/main/.forgejo/workflows) with the release assets
and the branches from https://codeberg.org/forgejo/forgejo.

## Forgejo runner publication

- Push the vX.Y.Z tag to https://code.forgejo.org/forgejo/runner

The release is built on https://code.forgejo.org/forgejo-integration/runner, which is a mirror of https://code.forgejo.org/forgejo/runner.

The release is published by
https://invisible.forgejo.org/forgejo/runner, which is a mirror
of https://code.forgejo.org/forgejo-integration/runner. Its role is to copy and sign release artifacts.

- Binaries are downloaded from https://code.forgejo.org/forgejo-integration/runner, signed and copied to https://code.forgejo.org/forgejo/runner.
- Container images are copied from https://code.forgejo.org/forgejo-integration to https://code.forgejo.org/forgejo
  It can also be done from the CLI with `forgejo-runner exec` and providing the secrets from the command line.
- Once the new version is published, wait 24h for renovate to propose a pull request titled `Update forgejo-runner to vX.Y.Z` (e.g. [Update forgejo-runner to v11.1.2](https://code.forgejo.org/forgejo/runner/pulls/1055))
- After merging the pull request titled `Update forgejo-runner to vX.Y.Z` ask a member of the devops team to upgrade the [runners hardware](https://code.forgejo.org/infrastructure/documentation/src/branch/main/runner-lxc.md) with:
  ```
  forgejo-runner-service.sh upgrade https://code.forgejo.org/forgejo/runner/raw/branch/main/examples/lxc-systemd/forgejo-runner-service.sh
  ```
  which is expected to display a line confirming the upgrade to `vX.Y.Z`. More information on that script can be [found in the README](https://code.forgejo.org/forgejo/runner/src/branch/main/examples/lxc-systemd#how-it-works).

## Release signing keys management

A GPG master key with no expiration date is created and shared with members of the Owners team via encrypted email. A subkey with a one year expiration date is created and stored in the secrets repository (`openpgp/20??-release-team.gpg`), to be used by the release pipeline. The public master key is stored in the secrets repository and published where relevant (keys.openpgp.org for instance).

### Securing the release token and cryptographic keys

For both the Forgejo runner and Forgejo itself, copying and signing the release artifacts (container images and binaries) happen on a Forgejo instance not publicly accessible to safeguard the token that has write access to the Forgejo repository as well as the cryptographic key used to sign the releases.

### Master key creation

- gpg --expert --full-generate-key
- key type: ECC and ECC option with Curve 25519 as curve
- no expiration
- id: Forgejo Releases <contact@forgejo.org>
  - gpg --export --armor EB114F5E6C0DC2BCDD183550A4B61A2DC5923710 > release-team.gpg.pub
- gpg --keyserver keys.openpgp.org --send-keys EB114F5E6C0DC2BCDD183550A4B61A2DC5923710
- gpg --export-secret-keys --armor EB114F5E6C0DC2BCDD183550A4B61A2DC5923710 | gopass cat openpgp/release-team-master.gpg

### Subkey creation and renewal

From the root of the secrets directory, assuming the master key for
EB114F5E6C0DC2BCDD183550A4B61A2DC5923710 is already imported in the
keyring.

There are a lot of contradictory information regarding the management
of subkeys, with zillions of ways of doing something that looks like it
could work but creates situations that are close to impossible to
figure out. Experimenting with the CLI, reading the gpg man page and
using common sense is the best way to understand how it works. Reading
the documentation or discussions on the net is highly confusing
because it is loaded with 20 years of history, most of which is no
longer relevant.

Here are a few notions that help understand how it works:

- `gpg --export-secret-subkeys --armor B3B1F60AC577F2A2!` exports the
  secret key for the subkey B3B1F60AC577F2A2, the exclamation mark
  meaning "nothing else".
- a `keygrip` is something that each private key has and that can be
  displayed with `gpg --with-keygrip --list-key`. It matters because each
  private key is associated with exactly one file in the `private-keys-v1.d`
  directory which is named after this keygrip. It is the best way to verify
  an unrelated private key was not accidentally included in the export of
  the subkey.
- when a subkey is created, the public key for the master key must be published
  again because it includes the public key of this new subkey.
- all the instructions that are published to instruct people to verify
  the signature of a release use the fingerprint of the master key. It will
  work although the release really is signed by the subkey and not the master
  key. This is the main benefit of using subkeys as it hides the rotation
  of the subkeys and does not require updating instructions everywhere every
  year.
- whenever gpg starts working with a new directory, it will launch a gpg-agent
  daemon that will persist. If this directory is removed manually or modified
  it will confuse the daemon and the gpg command will misbehave in ways
  that can be very difficult to understand. When experimenting
  create a new directory but do not modify the files manually, even though
  some instructions on the net recommend doing so, for instance to remove
  a private key.

#### Create

- mkdir /tmp/secrets && pushd /tmp/secrets
- gopass list openpgp
- gopass fscopy openpgp/20??-release-team.gpg 20??-release-team.gpg # for all years
- docker run -v ${PWD}:/tmp/secrets -ti --rm data.forgejo.org/oci/debian:bookworm bash
- apt update && apt install -y gnupg2
- gpg --import 20\*-release-team.gpg
- gpg --expert --edit-key EB114F5E6C0DC2BCDD183550A4B61A2DC5923710
- addkey
- key type: ECC (signature only)
- elliptic curve Curve 25519
- key validity: 18 months
- gpg --list-key --with-subkey-fingerprints # set FINGERPRINT to the fingerprint of the new subkey
- gpg --export-secret-subkeys --armor "${FINGERPRINT}!" > $(date +%Y)-release-team.gpg
- gpg --export --armor EB114F5E6C0DC2BCDD183550A4B61A2DC5923710 > openpgp/release-team.gpg.pub
- popd && rm -r /tmp/secrets

#### Sanity check

- mkdir /tmp/secrets && pushd /tmp/secrets
- gopass fscopy openpgp/release-team.gpg.pub release-team.gpg.pub
- gopass fscopy openpgp/20??-release-team.gpg 20??-release-team.gpg # year of the new subkey
- docker run -v ${PWD}:/tmp/secrets -ti --rm data.forgejo.org/oci/debian:bookworm bash
- apt update && apt install -y gnupg2
- cd /tmp/secrets
- export GNUPGHOME=/tmp/signrelease ; mkdir $GNUPGHOME ; chmod 700 $GNUPGHOME
- gpg --import 20??-release-team.gpg # year of the new subkey
- find $GNUPGHOME/private-keys-v1.d # only has **one** file named after the keygrip
- echo bar > /tmp/foo
- gpg --detach-sig --output /tmp/foo.asc --sign /tmp/foo
- export GNUPGHOME=/tmp/user ; mkdir $GNUPGHOME ; chmod 700 $GNUPGHOME
- gpg --import release-team.gpg.pub
- gpg --verify /tmp/foo.asc /tmp/foo
- popd && rm -r /tmp/secrets

#### Publish

- mkdir /tmp/secrets && pushd /tmp/secrets
- gopass fscopy openpgp/release-team.gpg.pub release-team.gpg.pub
- gpg --import release-team.gpg.pub
- gpg --keyserver keys.openpgp.org --send-keys EB114F5E6C0DC2BCDD183550A4B61A2DC5923710
- popd && rm -r /tmp/secrets

#### Reminder

- Set the date of the next sub-key creation reminder https://codeberg.org/forgejo/governance/issues/216

## Users, organizations and repositories

### Shared user: forgejo-cascading-pr

The [forgejo-cascading-pr](https://codeberg.org/forgejo-cascading-pr) user opens pull requests on behalf of other repositories by way of the [cascading-pr action](https://code.forgejo.org/actions/cascading-pr/). It is a regular user, not part of any team. It is only used for that purpose for security reasons.

### Dedicated user: forgejo-backport-action

The [forgejo-backport-action](https://codeberg.org/forgejo-backport-action) user opens backport pull requests on the forgejo repository. It is a member of the mergers team. The associated email is mailto:forgejo-backport-action@forgejo.org.

### Shared user: release-team

The [release-team](https://codeberg.org/release-team) user publishes and signs all releases. The associated email is mailto:release@forgejo.org.

The public GPG key used to sign the releases is [EB114F5E6C0DC2BCDD183550A4B61A2DC5923710](https://codeberg.org/release-team.gpg) `Forgejo Releases <release@forgejo.org>`

### Shared user: forgejo-experimental-ci

The [forgejo-experimental-ci](https://codeberg.org/forgejo-experimental-ci) user is dedicated to provide the application tokens used by the CI to build releases and publish them to https://codeberg.org/forgejo-experimental. It does not (and must not) have permission to publish releases at https://codeberg.org/forgejo.

### Dedicated user: forgejo-renovate-action

The [forgejo-renovate-action](https://codeberg.org/forgejo-renovate-action) user opens renovate pull requests on the forgejo repository. It is a member of the mergers team. The associated email is mailto:forgejo-renovate-action@forgejo.org.

### Integration and experimental organization

The https://codeberg.org/forgejo-integration organization is dedicated to integration testing. Its purpose is to ensure all artefacts can effectively be published and retrieved by the CI/CD pipelines.

The https://codeberg.org/forgejo-experimental organization is dedicated to publishing experimental Forgejo releases. They are copied from the https://codeberg.org/forgejo-integration organization.

The `forgejo-experimental-ci` user as well as all Forgejo contributors working on the CI/CD pipeline should be owners of both organizations.

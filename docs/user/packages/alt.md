---
title: 'Alt Package Registry'
license: 'Apache-2.0'
origin_url: 'https://codeberg.org/forgejo/docs/src/commit/8f46649aa9864b075c136c3a1eb86dc1d3579829/docs/user/packages/rpm.md'
---

Publish [Alt](https://www.altlinux.org/APT_в_ALT_Linux/CreateRepository) packages for your user or organization.

## Requirements

To work with the Alt registry, you need to use the APT-RPM package manager to consume packages.

The following examples use `apt-rpm`.

## Configuring the package registry

To register the RPM registry add the url to the list of known sources to the config file in the `/etc/apt/sources.list.d/` directory:

```shell
rpm https://forgejo.example.com/api/packages/{owner}/alt/{group}.repo {arch} classic
```

| Placeholder | Description                                                        |
| ----------- | ------------------------------------------------------------------ |
| `owner`     | The owner of the package.                                          |
| `group`     | Optional: Everything, e.g. empty, `el7`, `rocky/el9`, `test/fc38`. |
| `arch`      | Architecture.                                                      |

Example:

```shell
# without a group and architecture x86_64
rpm https://forgejo.example.com/api/packages/testuser/alt/alt.repo x86_64 classic

# with the group 'centos/el7' and architectire noarch
rpm https://forgejo.example.com/api/packages/testuser/alt/group/example1.repo noarch classic
```

If the registry is private, provide credentials in the url. You can use a password or a personal access token:

```shell
rpm https://{username}:{your_password_or_token}@forgejo.example.com/api/packages/{owner}/alt/{group}.repo {arch} classic
```

You have to add the credentials to the urls in the created `.repo` file in `/etc/apt/sources.list.d/` too.

## Publish a package

To publish a RPM package (`*.rpm`), perform a HTTP PUT operation with the package content in the request body.

```http
PUT https://forgejo.example.com/api/packages/{owner}/alt/{group}/upload
```

| Parameter | Description                                                        |
| --------- | ------------------------------------------------------------------ |
| `owner`   | The owner of the package.                                          |
| `group`   | Optional: Everything, e.g. empty, `el7`, `rocky/el9`, `test/fc38`. |

Example request using HTTP Basic authentication:

```shell
# without a group
curl --user your_username:your_password_or_token \
     --upload-file path/to/file.rpm \
     https://forgejo.example.com/api/packages/testuser/alt/upload
# with the group 'group/example1'
curl --user your_username:your_password_or_token \
     --upload-file path/to/file.rpm \
     https://forgejo.example.com/api/packages/testuser/alt/group/example1/upload
```

If you are using 2FA or OAuth use a personal access token instead of the password.
You cannot publish a file with the same name twice to a package. You must delete the existing package version first.

The server responds with the following HTTP Status codes.

| HTTP Status Code  | Meaning                                                                              |
| ----------------- | ------------------------------------------------------------------------------------ |
| `201 Created`     | The package has been published.                                                      |
| `400 Bad Request` | The package is invalid.                                                              |
| `409 Conflict`    | A package file with the same combination of parameters exist already in the package. |

## Delete a package

To delete a RPM package perform a HTTP DELETE operation. This will delete the package version too if there is no file left.

```http
DELETE https://forgejo.example.com/api/packages/{owner}/alt/{group}.repo/{architecture}/RPMS.classic/{package_file_name.rpm}
```

| Parameter               | Description                  |
| ----------------------- | ---------------------------- |
| `owner`                 | The owner of the package.    |
| `group`                 | Optional: The package group. |
| `package_file_name.rpm` | The package file name.       |
| `architecture`          | The package architecture.    |

Example request using HTTP Basic authentication:

```shell
# without a group
curl --user your_username:your_token_or_password -X DELETE \
     https://forgejo.example.com/api/packages/testuser/alt/alt.repo/x86_64/RPMS.classic/test-package.rpm

# with the group 'group/example1'
curl --user your_username:your_token_or_password -X DELETE \
     https://forgejo.example.com/api/packages/testuser/alt/group/example1.repo/x86_64/RPMS.classic/test-package.rpm
```

The server responds with the following HTTP Status codes.

| HTTP Status Code | Meaning                            |
| ---------------- | ---------------------------------- |
| `204 No Content` | Success                            |
| `404 Not Found`  | The package or file was not found. |

## Install a package

To install a package from the RPM registry, execute the following commands:

```shell
# use latest version
apt-get install {package_name}
# use specific version
apt-get install {package_name}-{package_version}
```

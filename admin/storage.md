---
title: 'Storage settings'
license: 'CC-BY-SA-4.0'
---

The storage for each subsystem (`attachments`, `lfs`, `avatars`,
`repo-avatars`, `repo-archive`, `packages`, `actions_log`,
`actions_artifact`) is defined in `app.ini`. It can either be on disk
(`local`) or using a MinIO server (`minio`). The default is `local`
storage, using the following hierarchy under the `WORK_PATH` directory:

| storage           | default base path  | app.ini sections                                   |
| ----------------- | ------------------ | -------------------------------------------------- |
| attachments       | attachments/       | [attachments] or [storage.attachements]            |
| lfs               | lfs/               | [lfs] or [storage.lfs]                             |
| avatars           | avatars/           | [avatars] or [storage.avatars]                     |
| repo-avatars      | repo-avatars/      | [repo-avatars] or [storage.repo-avatars]           |
| repo-archive      | repo-archive/      | [repo-archive] or [storage.repo-archive]           |
| packages          | packages/          | [packages] or [storage.packages]                   |
| actions_log       | actions_log/       | [actions_log] or [storage.actions_log]             |
| actions_artifacts | actions_artifacts/ | [actions_artifacts] or [storage.actions_artifacts] |

For instance if `WORK_PATH` was `/appdata`, the default directory to
store attachments would be `/appdata/attachements`.

## Overriding the defaults

These defaults can be modified for all subsystems in the `[storage]`
section. For instance setting:

```
[storage]
PATH = /mystorage
```

would change the default for storing attachements to
`/mystorage/attachments`. It is also possible to change these settings
for each subsystem in a `[storage.XXXX]` section. For instance setting:

```
[storage]
PATH = /mystorage

[storage.attachments]
PATH = /otherstorage/attachements
```

would store attachments in `/otherstorage/attachements` while `lfs`
files would be stored in `/mystorage/lfs`.

Finally, instead of using `[storage.XXXX]` it is also possible to use
`[XXXX]` as a shorthand.

## Storage type

The value of `STORAGE_TYPE` can be `local` (the default) or `minio`. For instance:

```
[storage]
STORAGE_TYPE = minio
```

Will use `minio` for all subsystems (`attachements`, `lfs`, etc.)
instead of storing them on disk. Each storage type has its own
settings, as explained below.

## `local` storage

There is just one setting when the `STORAGE_TYPE` is set to `local`,
`PATH`. For instance:

```
[storage]
STORAGE_TYPE = local
PATH = /mystorage
```

If the value of PATH for the `XXXX` subsystem is relative, it is
constructed as follows:

- The default base path is `WORK_PATH` (for instance `/appdata`)
- If `[storage].PATH` is relative (for instance `storage`), the default base path becomes `WORK_PATH`/`[storage].PATH` (for instance `/appdata/storage`)
- If `[storage.XXXX].PATH` is relative, the path becomes `WORK_PATH`/`[storage].PATH`/`[storage.XXXX].PATH` (for instance`/appdata/storage/lfs`)

It is recommended to always set the `PATH` values to an absolute path
name because it is easier to understand and maintain.

## `minio` storage

When the `STORAGE_TYPE` is set to `minio`, the settings available in
all sections (`[storage]`, `[storage.XXXX]` and `[XXXX]`) are:

- `SERVE_DIRECT`: **false**: Allows the storage driver to redirect to authenticated URLs to serve files directly. Only supported via signed URLs.
- `MINIO_ENDPOINT`: **localhost:9000**: Minio endpoint to connect.
- `MINIO_ACCESS_KEY_ID`: Minio accessKeyID to connect.
- `MINIO_SECRET_ACCESS_KEY`: Minio secretAccessKey to connect.
- `MINIO_BUCKET`: **gitea**: Minio bucket to store the data.
- `MINIO_LOCATION`: **us-east-1**: Minio location to create bucket.
- `MINIO_USE_SSL`: **false**: Minio enabled ssl.
- `MINIO_INSECURE_SKIP_VERIFY`: **false**: Minio skip SSL verification.

One setting is only available in the `[storage.XXXX]` or `[XXXX]` sections:

- `MINIO_BASE_PATH`: defaults to the `default base path` of the `XXXX`
  subsystem (see the table above) and is a relative path within the
  MinIO bucket defined by `MINIO_BUCKET`.

## Sections precedence

The sections in which a setting is found have the following priority:

- [XXXX] is first
- [storage.XXXX] is second
- [storage] is last

For instance:

```
[storage]
PATH = /last

[storage.attachments]
PATH = /second

[attachments]
PATH = /first
```

Will set the value of `PATH` for attachements to `/first`.

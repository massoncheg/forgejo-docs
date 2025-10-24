---
title: Forgejo CLI
license: 'CC-BY-SA-4.0'
---

<!--
This page should not be edited manually.
To update this page, run the following command from the root of the docs repo:
```
./scripts/cli-docs.sh > ./docs/admin/command-line.md
```
-->

## forgejo `--help`

```
NAME:
   forgejo - Beyond coding. We forge.

USAGE:
   forgejo [global options] [command [command options]]


DESCRIPTION:
   By default, forgejo will start serving using the web-server with no argument, which can alternatively be run by running the subcommand "web".

COMMANDS:
   help, h          Shows a list of commands or help for one command
   web              Start the Forgejo web server
   serv             (internal) Should only be called by SSH shell
   hook             (internal) Should only be called by Git
   keys             (internal) Should only be called by SSH server
   dump             Dump Forgejo files and database
   admin            Perform common administrative operations
   migrate          Migrate the database
   doctor           Diagnose and optionally fix problems, convert or re-create database tables
   manager          Manage the running forgejo process
   embedded         Extract embedded resources
   migrate-storage  Migrate the storage
   dump-repo        Dump the repository from git/github/gitea/gitlab
   restore-repo     Restore the repository from disk
   actions          Manage Forgejo Actions
   cert             Generate self-signed certificate
   generate         Generate Gitea's secrets/keys/tokens
   forgejo-cli      Forgejo CLI

GLOBAL OPTIONS:
   --version, -v                    print the version
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

## forgejo-cli

```
NAME:
   forgejo forgejo-cli - Forgejo CLI

USAGE:
   forgejo forgejo-cli [command [command options]]

COMMANDS:
   actions  Commands for managing Forgejo Actions
   f3       F3
```

### forgejo-cli actions

```
NAME:
   forgejo forgejo-cli actions - Commands for managing Forgejo Actions

USAGE:
   forgejo forgejo-cli actions [command [command options]]

COMMANDS:
   generate-runner-token  Generate a new token for a runner to use to register with the server
   generate-secret        Generate a secret suitable for input to the register subcommand
   register               Idempotent registration of a runner using a shared secret
```

### forgejo-cli actions generate-runner-token

```
NAME:
   forgejo forgejo-cli actions generate-runner-token - Generate a new token for a runner to use to register with the server

USAGE:
   forgejo forgejo-cli actions generate-runner-token

OPTIONS:
   --scope string, -s string  {owner}[/{repo}] - leave empty for a global runner
```

### forgejo-cli actions generate-secret

```
NAME:
   forgejo forgejo-cli actions generate-secret - Generate a secret suitable for input to the register subcommand

USAGE:
   forgejo forgejo-cli actions generate-secret
```

### forgejo-cli actions register

```
NAME:
   forgejo forgejo-cli actions register - Idempotent registration of a runner using a shared secret

USAGE:
   forgejo forgejo-cli actions register

OPTIONS:
   --secret string            the secret the runner will use to connect as a 40 character hexadecimal string
   --secret-stdin string      the secret the runner will use to connect as a 40 character hexadecimal string, read from stdin
   --secret-file string       path to the file containing the secret the runner will use to connect as a 40 character hexadecimal string
   --scope string, -s string  {owner}[/{repo}] - leave empty for a global runner
   --labels string            comma separated list of labels supported by the runner (e.g. docker,ubuntu-latest,self-hosted)  (not required since v1.21)
   --keep-labels              do not affect the labels when updating an existing runner
   --name string              name of the runner (default runner) (default: "runner")
   --version string           version of the runner (not required since v1.21)
```

### forgejo-cli f3

```
NAME:
   forgejo forgejo-cli f3 - F3

USAGE:
   forgejo forgejo-cli f3 [command [command options]]

GLOBAL OPTIONS:
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

## web

```
NAME:
   forgejo web - Start the Forgejo web server

USAGE:
   forgejo web

DESCRIPTION:
   The Forgejo web server is the only thing you need to run,
   and it takes care of all the other things for you

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --port string, -p string         Temporary port number to prevent conflict (default: "3000")
   --install-port string            Temporary port number to run the install page on to prevent conflict (default: "3000")
   --pid string, -P string          Custom pid file path (default: "/run/gitea.pid")
   --quiet, -q                      Only display Fatal logging errors until logging is set-up
   --verbose                        Set initial logging to TRACE level until logging is properly set-up
```

## dump

```
NAME:
   forgejo dump - Dump Forgejo files and database

USAGE:
   forgejo dump

DESCRIPTION:
   Dump compresses all related files and database into zip file.
   It can be used for backup and capture Forgejo server image to send to maintainer

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --file string, -f string         Name of the dump file which will be created. Supply '-' for stdout. See type for available types. (default: "forgejo-dump-<timestamp>.zip")
   --verbose, -V                    Show process details
   --quiet, -q                      Only display warnings and errors
   --tempdir string, -t string      Temporary dir path
   --database string, -d string     Specify the database SQL syntax: sqlite3, mysql, postgres
   --skip-repository, -R            Skip repositories
   --skip-log, -L                   Skip logs
   --skip-custom-dir                Skip custom directory
   --skip-lfs-data                  Skip LFS data
   --skip-attachment-data           Skip attachment data
   --skip-package-data              Skip package data
   --skip-index                     Skip bleve index data
   --skip-repo-archives             Skip repository archives
   --type value                     Dump output format: zip, tar, tar.sz, tar.gz, tar.xz, tar.bz2, tar.br, tar.lz4, tar.zst (default: zip)
```

## admin

```
NAME:
   forgejo admin - Perform common administrative operations

USAGE:
   forgejo admin [command [command options]]

COMMANDS:
   user                Modify users
   repo-sync-releases  Synchronize repository releases with tags
   regenerate          Regenerate specific files
   auth                Modify external auth providers
   sendmail            Send a message to all users

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

### admin user

```
NAME:
   forgejo admin user - Modify users

USAGE:
   forgejo admin user [command [command options]]

COMMANDS:
   create                 Create a new user in database
   list                   List users
   change-password        Change a user's password
   delete                 Delete specific user by id, name or email
   generate-access-token  Generate an access token for a specific user
   must-change-password   Set the must change password flag for the provided users or all users
   reset-mfa              Remove all two-factor authentication configurations for a user

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

### admin user create

```
NAME:
   forgejo admin user create - Create a new user in database

USAGE:
   forgejo admin user create

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --name string                    Username. DEPRECATED: use username instead
   --username string                Username
   --password string                User password
   --email string                   User email address
   --admin                          User is an admin
   --random-password                Generate a random password for the user
   --must-change-password           Set this option to false to prevent forcing the user to change their password after initial login
   --random-password-length int     Length of the random password to be generated (default: 12)
   --access-token                   Generate access token for the user
   --access-token-name string       Name of the generated access token (default: "gitea-admin")
   --access-token-scopes string     Scopes of the generated access token, comma separated. Examples: "all", "public-only,read:issue", "write:repository,write:user" (default: "all")
   --restricted                     Make a restricted user account
   --fullname string                The full, human-readable name of the user
```

### admin user list

```
NAME:
   forgejo admin user list - List users

USAGE:
   forgejo admin user list

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --admin                          List only admin users
```

### admin user change-password

```
NAME:
   forgejo admin user change-password - Change a user's password

USAGE:
   forgejo admin user change-password

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --username string, -u string     The user to change password for
   --password string, -p string     New password to set for user
   --must-change-password           User must change password
```

### admin user delete

```
NAME:
   forgejo admin user delete - Delete specific user by id, name or email

USAGE:
   forgejo admin user delete

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --id int                         ID of user of the user to delete (default: 0)
   --username string, -u string     Username of the user to delete
   --email string, -e string        Email of the user to delete
   --purge                          Purge user, all their repositories, organizations and comments
```

### admin user generate-access-token

```
NAME:
   forgejo admin user generate-access-token - Generate an access token for a specific user

USAGE:
   forgejo admin user generate-access-token

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --username string, -u string     Username
   --token-name string, -t string   Token name (default: "gitea-admin")
   --raw                            Display only the token value
   --scopes string                  Comma separated list of scopes to apply to access token, examples: "all", "public-only,read:issue", "write:repository,write:user" (default: "all")
```

### admin user must-change-password

```
NAME:
   forgejo admin user must-change-password - Set the must change password flag for the provided users or all users

USAGE:
   forgejo admin user must-change-password

OPTIONS:
   --help, -h                                                   show help
   --custom-path string, -C string                              Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string                                   Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string                                Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --all, -A                                                    All users must change password, except those explicitly excluded with --exclude
   --exclude string, -e string [ --exclude string, -e string ]  Do not change the must-change-password flag for these users
   --unset                                                      Instead of setting the must-change-password flag, unset it
```

### admin user reset-mfa

```
NAME:
   forgejo admin user reset-mfa - Remove all two-factor authentication configurations for a user

USAGE:
   forgejo admin user reset-mfa

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --username string, -u string     The user to update
```

### admin repo-sync-releases

```
NAME:
   forgejo admin repo-sync-releases - Synchronize repository releases with tags

USAGE:
   forgejo admin repo-sync-releases

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

### admin regenerate

```
NAME:
   forgejo admin regenerate - Regenerate specific files

USAGE:
   forgejo admin regenerate [command [command options]]

COMMANDS:
   hooks  Regenerate git-hooks
   keys   Regenerate authorized_keys file

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

### admin auth

```
NAME:
   forgejo admin auth - Modify external auth providers

USAGE:
   forgejo admin auth [command [command options]]

COMMANDS:
   add-oauth           Add new Oauth authentication source
   update-oauth        Update existing Oauth authentication source
   add-ldap            Add new LDAP (via Bind DN) authentication source
   update-ldap         Update existing LDAP (via Bind DN) authentication source
   add-ldap-simple     Add new LDAP (simple auth) authentication source
   update-ldap-simple  Update existing LDAP (simple auth) authentication source
   add-smtp            Add new SMTP authentication source
   update-smtp         Update existing SMTP authentication source
   list                List auth sources
   delete              Delete specific auth source

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

### admin auth add-oauth

```
NAME:
   forgejo admin auth add-oauth - Add new Oauth authentication source

USAGE:
   forgejo admin auth add-oauth

OPTIONS:
   --help, -h                           show help
   --custom-path string, -C string      Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string           Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string        Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --name string                        Application Name
   --provider string                    OAuth2 Provider
   --key string                         Client ID (Key)
   --secret string                      Client Secret
   --auto-discover-url string           OpenID Connect Auto Discovery URL (only required when using OpenID Connect as provider)
   --use-custom-urls string             Use custom URLs for GitLab/GitHub OAuth endpoints (default: "false")
   --custom-tenant-id string            Use custom Tenant ID for OAuth endpoints
   --custom-auth-url string             Use a custom Authorization URL (option for GitLab/GitHub)
   --custom-token-url string            Use a custom Token URL (option for GitLab/GitHub)
   --custom-profile-url string          Use a custom Profile URL (option for GitLab/GitHub)
   --custom-email-url string            Use a custom Email URL (option for GitHub)
   --icon-url string                    Custom icon URL for OAuth2 login source
   --skip-local-2fa                     Set to true to skip local 2fa for users authenticated by this source
   --scopes string [ --scopes string ]  Scopes to request when to authenticate against this OAuth2 source
   --attribute-ssh-public-key string    Claim name providing SSH public keys for this source
   --required-claim-name string         Claim name that has to be set to allow users to login with this source
   --required-claim-value string        Claim value that has to be set to allow users to login with this source
   --group-claim-name string            Claim name providing group names for this source
   --admin-group string                 Group Claim value for administrator users
   --restricted-group string            Group Claim value for restricted users
   --group-team-map string              JSON mapping between groups and org teams
   --group-team-map-removal             Activate automatic team membership removal depending on groups
   --allow-username-change              Allow users to change their username
```

### admin auth update-oauth

```
NAME:
   forgejo admin auth update-oauth - Update existing Oauth authentication source

USAGE:
   forgejo admin auth update-oauth

OPTIONS:
   --help, -h                           show help
   --custom-path string, -C string      Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string           Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string        Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --name string                        Application Name
   --id int                             ID of authentication source (default: 0)
   --provider string                    OAuth2 Provider
   --key string                         Client ID (Key)
   --secret string                      Client Secret
   --auto-discover-url string           OpenID Connect Auto Discovery URL (only required when using OpenID Connect as provider)
   --use-custom-urls string             Use custom URLs for GitLab/GitHub OAuth endpoints (default: "false")
   --custom-tenant-id string            Use custom Tenant ID for OAuth endpoints
   --custom-auth-url string             Use a custom Authorization URL (option for GitLab/GitHub)
   --custom-token-url string            Use a custom Token URL (option for GitLab/GitHub)
   --custom-profile-url string          Use a custom Profile URL (option for GitLab/GitHub)
   --custom-email-url string            Use a custom Email URL (option for GitHub)
   --icon-url string                    Custom icon URL for OAuth2 login source
   --skip-local-2fa                     Set to true to skip local 2fa for users authenticated by this source
   --scopes string [ --scopes string ]  Scopes to request when to authenticate against this OAuth2 source
   --attribute-ssh-public-key string    Claim name providing SSH public keys for this source
   --required-claim-name string         Claim name that has to be set to allow users to login with this source
   --required-claim-value string        Claim value that has to be set to allow users to login with this source
   --group-claim-name string            Claim name providing group names for this source
   --admin-group string                 Group Claim value for administrator users
   --restricted-group string            Group Claim value for restricted users
   --group-team-map string              JSON mapping between groups and org teams
   --group-team-map-removal             Activate automatic team membership removal depending on groups
   --allow-username-change              Allow users to change their username
```

### admin auth add-ldap

```
NAME:
   forgejo admin auth add-ldap - Add new LDAP (via Bind DN) authentication source

USAGE:
   forgejo admin auth add-ldap

OPTIONS:
   --help, -h                         show help
   --custom-path string, -C string    Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string         Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string      Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --name string                      Authentication name.
   --not-active                       Deactivate the authentication source.
   --active                           Activate the authentication source.
   --security-protocol string         Security protocol name.
   --skip-tls-verify                  Disable TLS verification.
   --host string                      The address where the LDAP server can be reached.
   --port int                         The port to use when connecting to the LDAP server. (default: 0)
   --user-search-base string          The LDAP base at which user accounts will be searched for.
   --user-filter string               An LDAP filter declaring how to find the user record that is attempting to authenticate.
   --admin-filter string              An LDAP filter specifying if a user should be given administrator privileges.
   --restricted-filter string         An LDAP filter specifying if a user should be given restricted status.
   --allow-deactivate-all             Allow empty search results to deactivate all users.
   --username-attribute string        The attribute of the user’s LDAP record containing the user name.
   --firstname-attribute string       The attribute of the user’s LDAP record containing the user’s first name.
   --surname-attribute string         The attribute of the user’s LDAP record containing the user’s surname.
   --email-attribute string           The attribute of the user’s LDAP record containing the user’s email address.
   --public-ssh-key-attribute string  The attribute of the user’s LDAP record containing the user’s public ssh key.
   --skip-local-2fa                   Set to true to skip local 2fa for users authenticated by this source
   --avatar-attribute string          The attribute of the user’s LDAP record containing the user’s avatar.
   --bind-dn string                   The DN to bind to the LDAP server with when searching for the user.
   --bind-password string             The password for the Bind DN, if any.
   --attributes-in-bind               Fetch attributes in bind DN context.
   --synchronize-users                Enable user synchronization.
   --disable-synchronize-users        Disable user synchronization.
   --page-size uint                   Search page size. (default: 0)
```

### admin auth update-ldap

```
NAME:
   forgejo admin auth update-ldap - Update existing LDAP (via Bind DN) authentication source

USAGE:
   forgejo admin auth update-ldap

OPTIONS:
   --help, -h                         show help
   --custom-path string, -C string    Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string         Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string      Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --id int                           ID of authentication source (default: 0)
   --name string                      Authentication name.
   --not-active                       Deactivate the authentication source.
   --active                           Activate the authentication source.
   --security-protocol string         Security protocol name.
   --skip-tls-verify                  Disable TLS verification.
   --host string                      The address where the LDAP server can be reached.
   --port int                         The port to use when connecting to the LDAP server. (default: 0)
   --user-search-base string          The LDAP base at which user accounts will be searched for.
   --user-filter string               An LDAP filter declaring how to find the user record that is attempting to authenticate.
   --admin-filter string              An LDAP filter specifying if a user should be given administrator privileges.
   --restricted-filter string         An LDAP filter specifying if a user should be given restricted status.
   --allow-deactivate-all             Allow empty search results to deactivate all users.
   --username-attribute string        The attribute of the user’s LDAP record containing the user name.
   --firstname-attribute string       The attribute of the user’s LDAP record containing the user’s first name.
   --surname-attribute string         The attribute of the user’s LDAP record containing the user’s surname.
   --email-attribute string           The attribute of the user’s LDAP record containing the user’s email address.
   --public-ssh-key-attribute string  The attribute of the user’s LDAP record containing the user’s public ssh key.
   --skip-local-2fa                   Set to true to skip local 2fa for users authenticated by this source
   --avatar-attribute string          The attribute of the user’s LDAP record containing the user’s avatar.
   --bind-dn string                   The DN to bind to the LDAP server with when searching for the user.
   --bind-password string             The password for the Bind DN, if any.
   --attributes-in-bind               Fetch attributes in bind DN context.
   --synchronize-users                Enable user synchronization.
   --disable-synchronize-users        Disable user synchronization.
   --page-size uint                   Search page size. (default: 0)
```

### admin auth add-ldap-simple

```
NAME:
   forgejo admin auth add-ldap-simple - Add new LDAP (simple auth) authentication source

USAGE:
   forgejo admin auth add-ldap-simple

OPTIONS:
   --help, -h                         show help
   --custom-path string, -C string    Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string         Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string      Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --name string                      Authentication name.
   --not-active                       Deactivate the authentication source.
   --active                           Activate the authentication source.
   --security-protocol string         Security protocol name.
   --skip-tls-verify                  Disable TLS verification.
   --host string                      The address where the LDAP server can be reached.
   --port int                         The port to use when connecting to the LDAP server. (default: 0)
   --user-search-base string          The LDAP base at which user accounts will be searched for.
   --user-filter string               An LDAP filter declaring how to find the user record that is attempting to authenticate.
   --admin-filter string              An LDAP filter specifying if a user should be given administrator privileges.
   --restricted-filter string         An LDAP filter specifying if a user should be given restricted status.
   --allow-deactivate-all             Allow empty search results to deactivate all users.
   --username-attribute string        The attribute of the user’s LDAP record containing the user name.
   --firstname-attribute string       The attribute of the user’s LDAP record containing the user’s first name.
   --surname-attribute string         The attribute of the user’s LDAP record containing the user’s surname.
   --email-attribute string           The attribute of the user’s LDAP record containing the user’s email address.
   --public-ssh-key-attribute string  The attribute of the user’s LDAP record containing the user’s public ssh key.
   --skip-local-2fa                   Set to true to skip local 2fa for users authenticated by this source
   --avatar-attribute string          The attribute of the user’s LDAP record containing the user’s avatar.
   --user-dn string                   The user's DN.
```

### admin auth update-ldap-simple

```
NAME:
   forgejo admin auth update-ldap-simple - Update existing LDAP (simple auth) authentication source

USAGE:
   forgejo admin auth update-ldap-simple

OPTIONS:
   --help, -h                         show help
   --custom-path string, -C string    Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string         Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string      Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --id int                           ID of authentication source (default: 0)
   --name string                      Authentication name.
   --not-active                       Deactivate the authentication source.
   --active                           Activate the authentication source.
   --security-protocol string         Security protocol name.
   --skip-tls-verify                  Disable TLS verification.
   --host string                      The address where the LDAP server can be reached.
   --port int                         The port to use when connecting to the LDAP server. (default: 0)
   --user-search-base string          The LDAP base at which user accounts will be searched for.
   --user-filter string               An LDAP filter declaring how to find the user record that is attempting to authenticate.
   --admin-filter string              An LDAP filter specifying if a user should be given administrator privileges.
   --restricted-filter string         An LDAP filter specifying if a user should be given restricted status.
   --allow-deactivate-all             Allow empty search results to deactivate all users.
   --username-attribute string        The attribute of the user’s LDAP record containing the user name.
   --firstname-attribute string       The attribute of the user’s LDAP record containing the user’s first name.
   --surname-attribute string         The attribute of the user’s LDAP record containing the user’s surname.
   --email-attribute string           The attribute of the user’s LDAP record containing the user’s email address.
   --public-ssh-key-attribute string  The attribute of the user’s LDAP record containing the user’s public ssh key.
   --skip-local-2fa                   Set to true to skip local 2fa for users authenticated by this source
   --avatar-attribute string          The attribute of the user’s LDAP record containing the user’s avatar.
   --user-dn string                   The user's DN.
```

### admin auth add-smtp

```
NAME:
   forgejo admin auth add-smtp - Add new SMTP authentication source

USAGE:
   forgejo admin auth add-smtp

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --name string                    Application Name
   --auth-type string               SMTP Authentication Type (PLAIN/LOGIN/CRAM-MD5) default PLAIN (default: "PLAIN")
   --host string                    SMTP Host
   --port int                       SMTP Port (default: 0)
   --force-smtps                    SMTPS is always used on port 465. Set this to force SMTPS on other ports.
   --skip-verify                    Skip TLS verify.
   --helo-hostname string           Hostname sent with HELO. Leave blank to send current hostname
   --disable-helo                   Disable SMTP helo.
   --allowed-domains string         Leave empty to allow all domains. Separate multiple domains with a comma (',')
   --skip-local-2fa                 Skip 2FA to log on.
   --active                         This Authentication Source is Activated.
```

### admin auth update-smtp

```
NAME:
   forgejo admin auth update-smtp - Update existing SMTP authentication source

USAGE:
   forgejo admin auth update-smtp

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --name string                    Application Name
   --id int                         ID of authentication source (default: 0)
   --auth-type string               SMTP Authentication Type (PLAIN/LOGIN/CRAM-MD5) default PLAIN (default: "PLAIN")
   --host string                    SMTP Host
   --port int                       SMTP Port (default: 0)
   --force-smtps                    SMTPS is always used on port 465. Set this to force SMTPS on other ports.
   --skip-verify                    Skip TLS verify.
   --helo-hostname string           Hostname sent with HELO. Leave blank to send current hostname
   --disable-helo                   Disable SMTP helo.
   --allowed-domains string         Leave empty to allow all domains. Separate multiple domains with a comma (',')
   --skip-local-2fa                 Skip 2FA to log on.
   --active                         This Authentication Source is Activated.
```

### admin auth list

```
NAME:
   forgejo admin auth list - List auth sources

USAGE:
   forgejo admin auth list

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --min-width int                  Minimal cell width including any padding for the formatted table (default: 0)
   --tab-width int                  width of tab characters in formatted table (equivalent number of spaces) (default: 8)
   --padding int                    padding added to a cell before computing its width (default: 1)
   --pad-char string                ASCII char used for padding if padchar == '\\t', the Writer will assume that the width of a '\\t' in the formatted output is tabwidth, and cells are left-aligned independent of align_left (for correct-looking results, tabwidth must correspond to the tab width in the viewer displaying the result) (default: "\t")
   --vertical-bars                  Set to true to print vertical bars between columns
```

### admin auth delete

```
NAME:
   forgejo admin auth delete - Delete specific auth source

USAGE:
   forgejo admin auth delete

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --id int                         ID of authentication source (default: 0)
```

### admin sendmail

```
NAME:
   forgejo admin sendmail - Send a message to all users

USAGE:
   forgejo admin sendmail

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --title string                   a title of a message
   --content string                 a content of a message
   --force, -f                      A flag to bypass a confirmation step
```

## migrate

```
NAME:
   forgejo migrate - Migrate the database

USAGE:
   forgejo migrate

DESCRIPTION:
   This is a command for migrating the database, so that you can run 'forgejo admin user create' before starting the server.

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

## keys

```
NAME:
   forgejo keys - (internal) Should only be called by SSH server

USAGE:
   forgejo keys

DESCRIPTION:
   Queries the Forgejo database to get the authorized command for a given ssh key fingerprint

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --expected string, -e string     Expected user for whom provide key commands (default: "git")
   --username string, -u string     Username trying to log in by SSH
   --type string, -t string         Type of the SSH key provided to the SSH Server (requires content to be provided too)
   --content string, -k string      Base64 encoded content of the SSH key provided to the SSH Server (requires type to be provided too)
```

## doctor

```
NAME:
   forgejo doctor - Diagnose and optionally fix problems, convert or re-create database tables

USAGE:
   forgejo doctor [command [command options]]

DESCRIPTION:
   A command to diagnose problems with the current Forgejo instance according to the given configuration. Some problems can optionally be fixed by modifying the database or data storage.

COMMANDS:
   check              Diagnose and optionally fix problems
   recreate-table     Recreate tables from XORM definitions and copy the data.
   convert            Convert the database
   avatar-strip-exif  Strip EXIF metadata from all images in the avatar storage

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

### doctor check

```
NAME:
   forgejo doctor check - Diagnose and optionally fix problems

USAGE:
   forgejo doctor check

DESCRIPTION:
   A command to diagnose problems with the current Forgejo instance according to the given configuration. Some problems can optionally be fixed by modifying the database or data storage.

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --list                           List the available checks
   --default                        Run the default checks (if neither --run or --all is set, this is the default behaviour)
   --run string [ --run string ]    Run the provided checks - (if --default is set, the default checks will also run)
   --all                            Run all the available checks
   --fix                            Automatically fix what we can
   --log-file string                Name of the log file (no verbose log output by default). Set to "-" to output to stdout
   --color, -H                      Use color for outputted information
```

### doctor recreate-table

```
NAME:
   forgejo doctor recreate-table - Recreate tables from XORM definitions and copy the data.

USAGE:
   forgejo doctor recreate-table [TABLE]... : (TABLEs to recreate - leave blank for all)

DESCRIPTION:
   The database definitions Forgejo uses change across versions, sometimes changing default values and leaving old unused columns.

   This command will cause Xorm to recreate tables, copying over the data and deleting the old table.

   You should back-up your database before doing this and ensure that your database is up-to-date first.

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --debug                          Print SQL commands sent
```

### doctor convert

```
NAME:
   forgejo doctor convert - Convert the database

USAGE:
   forgejo doctor convert

DESCRIPTION:
   A command to convert an existing MySQL database from utf8 to utf8mb4

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

### doctor avatar-strip-exif

```
NAME:
   forgejo doctor avatar-strip-exif - Strip EXIF metadata from all images in the avatar storage

USAGE:
   forgejo doctor avatar-strip-exif

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

## manager

```
NAME:
   forgejo manager - Manage the running forgejo process

USAGE:
   forgejo manager [command [command options]]

DESCRIPTION:
   This is a command for managing the running forgejo process

COMMANDS:
   shutdown          Gracefully shutdown the running process
   restart           Gracefully restart the running process - (not implemented for windows servers)
   reload-templates  Reload template files in the running process
   flush-queues      Flush queues in the running process
   logging           Adjust logging commands
   processes         Display running processes within the current process

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

### manager shutdown

```
NAME:
   forgejo manager shutdown - Gracefully shutdown the running process

USAGE:
   forgejo manager shutdown

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --debug
```

### manager restart

```
NAME:
   forgejo manager restart - Gracefully restart the running process - (not implemented for windows servers)

USAGE:
   forgejo manager restart

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --debug
```

### manager reload-templates

```
NAME:
   forgejo manager reload-templates - Reload template files in the running process

USAGE:
   forgejo manager reload-templates

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --debug
```

### manager flush-queues

```
NAME:
   forgejo manager flush-queues - Flush queues in the running process

USAGE:
   forgejo manager flush-queues

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --timeout duration               Timeout for the flushing process (default: 1m0s)
   --non-blocking                   Set to true to not wait for flush to complete before returning
   --debug
```

### manager logging

```
NAME:
   forgejo manager logging - Adjust logging commands

USAGE:
   forgejo manager logging [command [command options]]

COMMANDS:
   pause               Pause logging (Forgejo will buffer logs up to a certain point and will drop them after that point)
   resume              Resume logging
   release-and-reopen  Cause Forgejo to release and re-open files used for logging
   remove              Remove a logger
   add                 Add a logger
   log-sql             Set LogSQL

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

### manager logging pause

```
NAME:
   forgejo manager logging pause - Pause logging (Forgejo will buffer logs up to a certain point and will drop them after that point)

USAGE:
   forgejo manager logging pause

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --debug
```

### manager logging resume

```
NAME:
   forgejo manager logging resume - Resume logging

USAGE:
   forgejo manager logging resume

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --debug
```

### manager logging release-and-reopen

```
NAME:
   forgejo manager logging release-and-reopen - Cause Forgejo to release and re-open files used for logging

USAGE:
   forgejo manager logging release-and-reopen

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --debug
```

### manager logging remove

```
NAME:
   forgejo manager logging remove - Remove a logger

USAGE:
   forgejo manager logging remove [name] Name of logger to remove

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --debug
   --logger string                  Logger name - will default to "default"
```

### manager logging add

```
NAME:
   forgejo manager logging add - Add a logger

USAGE:
   forgejo manager logging add [command [command options]]

COMMANDS:
   file  Add a file logger
   conn  Add a net conn logger

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

### manager logging add file

```
NAME:
   forgejo manager logging add file - Add a file logger

USAGE:
   forgejo manager logging add file

OPTIONS:
   --help, -h                            show help
   --custom-path string, -C string       Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string            Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string         Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --logger string                       Logger name - will default to "default"
   --writer string                       Name of the log writer - will default to mode
   --level string                        Logging level for the new logger
   --stacktrace-level string, -L string  Stacktrace logging level
   --flags string, -F string             Flags for the logger
   --expression string, -e string        Matching expression for the logger
   --exclusion string, -x string         Exclusion for the logger
   --prefix string, -p string            Prefix for the logger
   --color                               Use color in the logs
   --debug
   --filename string, -f string          Filename for the logger - this must be set.
   --rotate, -r                          Rotate logs
   --max-size int, -s int                Maximum size in bytes before rotation (default: 0)
   --daily, -d                           Rotate logs daily
   --max-days int, -D int                Maximum number of daily logs to keep (default: 0)
   --compress, -z                        Compress rotated logs
   --compression-level int, -Z int       Compression level to use (default: 0)
```

### manager logging add conn

```
NAME:
   forgejo manager logging add conn - Add a net conn logger

USAGE:
   forgejo manager logging add conn

OPTIONS:
   --help, -h                            show help
   --custom-path string, -C string       Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string            Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string         Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --logger string                       Logger name - will default to "default"
   --writer string                       Name of the log writer - will default to mode
   --level string                        Logging level for the new logger
   --stacktrace-level string, -L string  Stacktrace logging level
   --flags string, -F string             Flags for the logger
   --expression string, -e string        Matching expression for the logger
   --exclusion string, -x string         Exclusion for the logger
   --prefix string, -p string            Prefix for the logger
   --color                               Use color in the logs
   --debug
   --reconnect-on-message, -R            Reconnect to host for every message
   --reconnect, -r                       Reconnect to host when connection is dropped
   --protocol string, -P string          Set protocol to use: tcp, unix, or udp (defaults to tcp)
   --address string, -a string           Host address and port to connect to (defaults to :7020)
```

### manager logging log-sql

```
NAME:
   forgejo manager logging log-sql - Set LogSQL

USAGE:
   forgejo manager logging log-sql

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --debug
   --off                            Switch off SQL logging
```

### manager processes

```
NAME:
   forgejo manager processes - Display running processes within the current process

USAGE:
   forgejo manager processes

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --debug
   --flat                           Show processes as flat table rather than as tree
   --no-system                      Do not show system processes
   --stacktraces                    Show stacktraces
   --json                           Output as json
   --cancel string                  Process PID to cancel. (Only available for non-system processes.)
```

## embedded

```
NAME:
   forgejo embedded - Extract embedded resources

USAGE:
   forgejo embedded [command [command options]]

DESCRIPTION:
   A command for extracting embedded resources, like templates and images

COMMANDS:
   list     List files matching the given pattern
   view     View a file matching the given pattern
   extract  Extract resources

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
```

### embedded list

```
NAME:
   forgejo embedded list - List files matching the given pattern

USAGE:
   forgejo embedded list

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --include-vendored, --vendor     Include files under public/vendor as well
```

### embedded view

```
NAME:
   forgejo embedded view - View a file matching the given pattern

USAGE:
   forgejo embedded view

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --include-vendored, --vendor     Include files under public/vendor as well
```

### embedded extract

```
NAME:
   forgejo embedded extract - Extract resources

USAGE:
   forgejo embedded extract

OPTIONS:
   --help, -h                               show help
   --custom-path string, -C string          Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string               Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string            Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --include-vendored, --vendor             Include files under public/vendor as well
   --overwrite                              Overwrite files if they already exist
   --rename                                 Rename files as {name}.bak if they already exist (overwrites previous .bak)
   --custom                                 Extract to the 'custom' directory as per app.ini
   --destination string, --dest-dir string  Extract to the specified directory
```

## migrate-storage

```
NAME:
   forgejo migrate-storage - Migrate the storage

USAGE:
   forgejo migrate-storage

DESCRIPTION:
   Copies stored files from storage configured in app.ini to parameter-configured storage

OPTIONS:
   --help, -h                         show help
   --custom-path string, -C string    Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string         Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string      Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --type string, -t string           Type of stored files to copy.  Allowed types: 'attachments', 'lfs', 'avatars', 'repo-avatars', 'repo-archivers', 'packages', 'actions-log', 'actions-artifacts'
   --storage string, -s string        New storage type: local (default) or minio
   --path string, -p string           New storage placement if store is local (leave blank for default)
   --minio-endpoint string            Minio storage endpoint
   --minio-access-key-id string       Minio storage accessKeyID
   --minio-secret-access-key string   Minio storage secretAccessKey
   --minio-bucket string              Minio storage bucket
   --minio-location string            Minio storage location to create bucket
   --minio-base-path string           Minio storage base path on the bucket
   --minio-use-ssl                    Enable SSL for minio
   --minio-insecure-skip-verify       Skip SSL verification
   --minio-checksum-algorithm string  Minio checksum algorithm (default/md5)
```

## dump-repo

```
NAME:
   forgejo dump-repo - Dump the repository from git/github/gitea/gitlab

USAGE:
   forgejo dump-repo

DESCRIPTION:
   This is a command for dumping the repository data.

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --git_service string             Git service, git, github, gitea, gitlab. If clone_addr could be recognized, this could be ignored.
   --repo_dir string, -r string     Repository dir path to store the data (default: "./data")
   --clone_addr string              The URL will be clone, currently could be a git/github/gitea/gitlab http/https URL
   --auth_username string           The username to visit the clone_addr
   --auth_password string           The password to visit the clone_addr
   --auth_token string              The personal token to visit the clone_addr
   --owner_name string              The data will be stored on a directory with owner name if not empty
   --repo_name string               The data will be stored on a directory with repository name if not empty
   --units string                   Which items will be migrated, one or more units should be separated as comma.
      wiki, issues, labels, releases, release_assets, milestones, pull_requests, comments are allowed. Empty means all units.
```

## restore-repo

```
NAME:
   forgejo restore-repo - Restore the repository from disk

USAGE:
   forgejo restore-repo

DESCRIPTION:
   This is a command for restoring the repository data.

OPTIONS:
   --help, -h                       show help
   --custom-path string, -C string  Set custom path (defaults to '{WorkPath}/custom')
   --config string, -c string       Set custom config file (defaults to '{WorkPath}/custom/conf/app.ini')
   --work-path string, -w string    Set Forgejo's working path (defaults to the directory of the Forgejo binary)
   --repo_dir string, -r string     Repository dir path to restore from (default: "./data")
   --owner_name string              Restore destination owner name
   --repo_name string               Restore destination repository name
   --units string                   Which items will be restored, one or more units should be separated as comma.
      wiki, issues, labels, releases, release_assets, milestones, pull_requests, comments are allowed. Empty means all units.
   --validation  Sanity check the content of the files before trying to load them
```

## cert

```
NAME:
   forgejo cert - Generate self-signed certificate

USAGE:
   forgejo cert

DESCRIPTION:
   Generate a self-signed X.509 certificate for a TLS server.
   Outputs to 'cert.pem' and 'key.pem' and will overwrite existing files.

OPTIONS:
   --host string         Comma-separated hostnames and IPs to generate a certificate for
   --ecdsa-curve string  ECDSA curve to use to generate a key. Valid values are P224, P256, P384, P521
   --rsa-bits int        Size of RSA key to generate. Ignored if --ecdsa-curve is set (default: 3072)
   --start-date string   Creation date formatted as Jan 1 15:04:05 2011
   --duration duration   Duration that certificate is valid for (default: 8760h0m0s)
   --ca                  whether this cert should be its own Certificate Authority
```

## generate secret

```
NAME:
   forgejo generate secret - Generate a secret token

USAGE:
   forgejo generate secret [command [command options]]

COMMANDS:
   INTERNAL_TOKEN              Generate a new INTERNAL_TOKEN
   JWT_SECRET, LFS_JWT_SECRET  Generate a new JWT_SECRET
   SECRET_KEY                  Generate a new SECRET_KEY
```

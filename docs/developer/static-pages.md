---
title: Static pages
license: 'CC-BY-SA-4.0'
---

LXC container dedicated to hosting static HTML pages.

# LXC container

See the [static-pages section in the infrastructure documentation](../infrastructure/).

# SSL on the LXC host

Each domain has a `/etc/nginx/sites-enabled/f3.forgefriends.forgejo.org` file similar to the following
on the host where the LXC container resides.

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name f3.forgefriends.forgejo.org;

    location / {
        proxy_pass http://10.6.83.106:80;
    }
}
```

Obtain the certificate:

```sh
sudo certbot -n --agree-tos --email contact@forgejo.org -d f3.forgefriends.forgejo.org --nginx
```

# Creation in the LXC container

With the example of `f3.forgefriends.forgejo.org` and
`f3.forgefriends.org` serving the same content.

## login

From the LXC host:

```sh
lxc-helpers.sh lxc_container_run static-pages -- sudo --user $USER bash
```

## nginx

```
server {
        listen 80;

        server_name f3.forgefriends.org f3.forgefriends.forgejo.org;

        root /var/www/f3.forgefriends.org;

        location / {
                try_files $uri $uri/ =404;
        }
}
```

## clone

```sh
git clone https://code.forgejo.org/f3/html-documentation /var/www/f3.forgefriends.org
```

# Update in the LXC container

## Webhook

Create a `POST` webhook with the URL `https://f3.forgefriends.forgejo.org/.well-known/forgejo/f3.forgefriends.org` on https://code.forgejo.org/f3/html-documentation. It is expected to fail with 404, the information will be extracted from the web server logs.

## Service

### git pull on change

```sh
$ cat /usr/local/bin/static-pages.sh
sudo tail -f /var/log/nginx/access.log | sed --silent --regexp-extended --unbuffered --expression 's|.*.well-known/forgejo/([^ ]+) .*|\1|p' | while read server ; do
    d="/var/www/$server"
    if test -d "$d" ; then
        echo "update $server"
        cd "$d"
        git pull
    fi
done
```

### service

```sh
$ cat /etc/systemd/system/static-pages.service
[Unit]
Description=Static pages

[Service]
User=debian
ExecStart=/usr/local/bin/static-pages.sh

[Install]
WantedBy=multi-user.target
$ sudo systemctl enable static-pages
```

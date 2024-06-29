---
title: Hardware infrastructure
license: 'CC-BY-SA-4.0'
---

## LXC Hosts

All LXC hosts are setup with [lxc-helpers](https://code.forgejo.org/forgejo/lxc-helpers/).

```sh
name=forgejo-host
lxc-helpers.sh lxc_container_run $name -- sudo --user debian bash
```

### Unprivileged

```sh
name=forgejo-host
lxc-helpers.sh lxc_container_create --config "unprivileged" $name
echo "lxc.start.auto = 1" | sudo tee -a /var/lib/lxc/$name/config
lxc-helpers.sh lxc_container_start $name
lxc-helpers.sh lxc_container_user_install $name $(id -u) $USER
```

### Docker enabled

```sh
name=forgejo-host
lxc-helpers.sh lxc_container_create --config "docker" $name
echo "lxc.start.auto = 1" | sudo tee -a /var/lib/lxc/$name/config
lxc-helpers.sh lxc_container_start $name
lxc-helpers.sh lxc_install_docker $name
lxc-helpers.sh lxc_container_user_install $name $(id -u) $USER
```

### Docker and LXC enabled

```sh
name=forgejo-host
ipv4=10.85.12
ipv6=fc33
lxc-helpers.sh lxc_container_create --config "docker lxc" $name
echo "lxc.start.auto = 1" | sudo tee -a /var/lib/lxc/$name/config
lxc-helpers.sh lxc_container_start $name
lxc-helpers.sh lxc_install_docker $name
lxc-helpers.sh lxc_install_lxc $name $ipv4 $ipv6
lxc-helpers.sh lxc_container_user_install $name $(id -u) $USER
```

## nftables

```sh
sudo nft list ruleset
```

## Host reverse proxy

The reverse proxy on a host forwards to the designated LXC container with
something like the following examples in
`/etc/nginx/sites-available/example.com`, where A.B.C.D is the
IP allocated to the LXC container running the web service.

And symlink:

```sh
ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/example.com
```

The certificate is obtained once and automatically renewed with:

```
sudo apt-get install certbot python3-certbot-nginx
sudo certbot -n --agree-tos --email contact@forgejo.org -d example.com --nginx
```

When removing a configuration, the certificate can also be removed with:

```
sudo certbot delete --cert-name example.com
```

### Forgejo example

```
server {
    listen 80;
    listen [::]:80;

    server_name example.com;

    location / {
        proxy_pass http://A.B.C.D:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        client_max_body_size 2G;
    }
}
```

### GitLab example

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name example.com;

    location / {
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection "upgrade";
       proxy_set_header Host $http_host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header X-Forwarded-Proto $scheme;
       proxy_set_header X-Frame-Options SAMEORIGIN;

       client_body_timeout 60;
       client_max_body_size 200M;
       send_timeout 1200;
       lingering_timeout 5;

       proxy_buffering off;
       proxy_connect_timeout 90;
       proxy_send_timeout 300;
       proxy_read_timeout 600s;

       proxy_pass http://example.com;
       proxy_http_version 1.1;
    }
}
```

### Vanila example

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name example.com;

    location / {
        proxy_pass http://A.B.C.D;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```

## Forgejo runners

The LXC container in which the runner is installed must have capabilities that support the backend.

- docker:// needs a Docker enabled container
- lxc:// needs a Docker and LXC enabled container

The runners it contains are not started at boot, it must be done manually. The bash history has the command line to do so.

### Installation

```shell
version=3.5.0
sudo wget -O /usr/local/bin/forgejo-runner-$version https://code.forgejo.org/forgejo/runner/releases/download/v$version/forgejo-runner-$version-linux-amd64
sudo chmod +x /usr/local/bin/forgejo-runner-$version
echo 'export TERM=xterm-256color' >> .bashrc
```

### Creating a runner

Multiple runners can co-exist on the same machine. To keep things
organized they are located in a directory that is the same as the URL
from which the token is obtained. For instance
DIR=codeberg.org/forgejo-integration means that the token was obtained from the
https://codeberg.org/forgejo-integration organization.

If a runner only provides unprivileged docker containers, the labels
in `config.yml` should be:
`labels: ['docker:docker://node:20-bookworm']`.

If a runner provides LXC containers and unprivileged docker
containers, the labels in `config.yml` should be
`labels: ['self-hosted:lxc://debian:bookworm', 'docker:docker://node:20-bookworm']`.

```shell
name=myrunner
mkdir -p $DIR ; cd $DIR
forgejo-runner generate-config > config-$name.yml
## edit config-$name.yml and adjust the `labels:`
## Obtain a $TOKEN from https://$DIR
forgejo-runner-$version register --no-interactive --token $TOKEN --name runner --instance https://codeberg.org
forgejo-runner-$version --config config-$name.yml daemon |& cat -v > runner.log &
```

## Octopuce

[Octopuce provides hardware](https://codeberg.org/forgejo/sustainability) managed by [the devops team](https://codeberg.org/forgejo/governance/src/branch/main/TEAMS.md#devops). It can only be accessed via SSH.

To access the services hosted on the LXC containers, ssh port forwarding to the private IPs can be used. For instance:

```sh
echo 127.0.0.1 private.forgejo.org >> /etc/hosts
sudo ssh -i ~/.ssh/id_rsa -L 80:10.77.0.128:80 debian@forgejo01.octopuce.fr
firefox http://private.forgejo.org
```

### Containers

- `fogejo-host`

  Dedicated to http://private.forgejo.org

  - Docker enabled
  - upgrades checklist:
    ```sh
    emacs /home/debian/run-forgejo.sh # change the `image=`
    docker stop forgejo
    sudo rsync -av --numeric-ids --delete --progress /srv/forgejo/ /root/forgejo-backup/
    docker rm forgejo
    bash -x /home/debian/run-forgejo.sh
    docker logs -n 200 -f forgejo
    ```

- `fogejo-runner-host`

  Has runners installed to run against private.forgejo.org

  - Docker and LXC enabled 10.85.12 fc33

## Hetzner

All hardware machines are running Debian GNU/linux bookworm. They are LXC hosts
setup with [lxc-helpers](https://code.forgejo.org/forgejo/lxc-helpers/).

> **NOTE:** only use [EX101 with a ASRockRack W680D4U-1L motherboard](https://forum.hetzner.com/index.php?thread/31135-all-ex101-with-asustek-w680-crash-on-sequential-read/).

### vSwitch

A vSwitch is assigned via the Robot console on all servers for backend communications
and [configured](https://docs.hetzner.com/robot/dedicated-server/network/vswitch#example-debian-configuration)
in /etc/network/interfaces for each of them with something like:

```
auto enp5s0.4000
iface enp5s0.4000 inet static
  address 10.53.100.2
  netmask 255.255.255.0
  vlan-raw-device enp5s0
  mtu 1400
```

The IP address ends with the same number as the hardware (hetzner02 => .2).

### DRBD

DRBD is [configured](https://linbit.com/drbd-user-guide/drbd-guide-9_0-en/#p-work) like in the following example with hetzner02 as the primary and hetzner03 as the secondary:

```sh
$ apt-get install drbd-utils
$ cat /etc/drbd.d/r0.res
resource r0 {
    net {
        # A : write completion is determined when data is written to the local disk and the local TCP transmission buffer
        # B : write completion is determined when data is written to the local disk and remote buffer cache
        # C : write completion is determined when data is written to both the local disk and the remote disk
        protocol C;
        cram-hmac-alg sha1;
        # any secret key for authentication among nodes
        shared-secret "***";
    }
    disk {
        resync-rate 1000M;
    }
    on hetzner02 {
        address 10.53.100.2:7788;
        volume 0 {
            # device name
            device /dev/drbd0;
            # specify disk to be used for device above
            disk /dev/nvme0n1p5;
            # where to create metadata
            # specify the block device name when using a different disk
            meta-disk internal;
        }
    }
    on hetzner03 {
        address 10.53.100.3:7788;
        volume 0 {
            device /dev/drbd0;
            disk /dev/nvme1n1p5;
            meta-disk internal;
        }
    }
}
$ sudo drbdadm create-md r0
$ sudo drbdadm up r0
```

On hetzner02 (the primary), [pretend all is in sync](https://linbit.com/drbd-user-guide/drbd-guide-9_0-en/#s-skip-initial-resync) to save the initial bitmap sync since
there is actually no data at all.

```sh
sudo drbdadm new-current-uuid --clear-bitmap r0/0
```

The DRBD device is mounted on `/var/lib/lxc` in `/etc/fstab` there is a noauto line:

```
/dev/drbd0 /var/lib/lxc ext4 noauto,defaults 0 0
```

To prevent split brain situations a manual step is required at boot
time, on the machine that is going to be the primary.

```sh
sudo drbdadm up r0
sudo drbdsetup status
sudo drbdadm primary r0
sudo mount /var/lib/lxc
sudo lxc-autostart start
sudo lxc-ls -f
sudo drbdsetup status
```

### hetzner{01,04}

https://hetzner{01,04}.forgejo.org run on [EX101](https://www.hetzner.com/dedicated-rootserver/ex101) Hetzner hardware.

#### LXC

```sh
lxc-helpers.sh lxc_install_lxc_inside 10.41.13 fc29
```

#### Disk partitioning

- First disk
  - OS
  - a partition mounted on /srv where non precious data goes such as the LXC containers with runners.
- Second disk
  - configured with DRBD for precious data.

#### Root filesystem backups

- `hetzner01:/etc/cron.daily/backup-hetzner04`
  `rsync -aHS --delete-excluded --delete --numeric-ids --exclude /proc --exclude /dev --exclude /sys --exclude /precious --exclude /srv --exclude /var/lib/lxc 10.53.100.4:/ /srv/backups/hetzner04/ >& /var/log/$(basename $0).log`
- `hetzner04:/etc/cron.daily/backup-hetzner01`
  `rsync -aHS --delete-excluded --delete --numeric-ids --exclude /proc --exclude /dev --exclude /sys --exclude /precious --exclude /srv --exclude /var/lib/lxc 10.53.100.1:/ /srv/backups/hetzner01/ >& /var/log/$(basename $0).log`

#### LXC containers

- `runner-lxc-helpers` (hetzner01)

  Dedicated to Forgejo runners for the https://code.forgejo.org/forgejo/lxc-helpers project.

  - K8S enabled
  - code.forgejo.org/forgejo/lxc-helpers/config\*.yml

- `forgejo-runners` (hetzner01)

  Dedicated to Forgejo runners for the https://codeberg.org/forgejo organization.

  - Docker enabled
  - codeberg.org/forgejo/config\*.yml

- `runner01-lxc` (hetzner01)

  Dedicated to Forgejo runners for https://code.forgejo.org.

  - Docker and LXC enabled 10.194.201 fc35
  - code.forgejo.org/forgejo/config\*.yml
  - code.forgejo.org/actions/config\*.yml
  - code.forgejo.org/forgejo-integration/config\*.yml
  - code.forgejo.org/forgejo-contrib/config\*.yml
  - code.forgejo.org/f3/config\*.yml
  - code.forgejo.org/forgefriends/config\*.yml

- `forgefriends-forum` (hetzner04)

  Dedicated to https://forum.forgefriends.org

  - Docker enabled

- `forgefriends-gitlab` (hetzner04)

  Dedicated to https://lab.forgefriends.org

  - Docker enabled

- `forgefriends-cloud` (hetzner04)

  Dedicated to https://cloud.forgefriends.org

  - Docker enabled

- `gna-forgejo` (hetzner04)

  Dedicated to https://forgejo.gna.org

  - Docker enabled

- `gna-forum` (hetzner04)

  Dedicated to https://forum.gna.org

  - Docker enabled

### hetzner{02,03}

https://hetzner02.forgejo.org & https://hetzner03.forgejo.org run on [EX44](https://www.hetzner.com/dedicated-rootserver/ex44) Hetzner hardware.

#### LXC

```sh
lxc-helpers.sh lxc_install_lxc_inside 10.6.83 fc16
```

#### Disk partitioning

- First disk
  - OS
  - a partition configured with DRBD for precious data mounted on /var/lib/lxc
- Second disk
  - non precious data such as the LXC containers with runners.

#### Root filesystem backups

- `hetzner03:/etc/cron.daily/backup-hetzner02`
  `rsync -aHS --delete-excluded --delete --numeric-ids --exclude /proc --exclude /dev --exclude /sys --exclude /srv --exclude /var/lib/lxc 10.53.100.2:/ /srv/backups/hetzner02/`
- `hetzner02:/etc/cron.daily/backup-hetzner03`
  `rsync -aHS --delete-excluded --delete --numeric-ids --exclude /proc --exclude /dev --exclude /sys --exclude /srv --exclude /var/lib/lxc 10.53.100.3:/ /srv/backups/hetzner03/`

#### Public IP addresses

The public IP addresses attached to the hosts are not failover IPs that can be moved from one host to the next.
The DNS entry needs to be updated if the primary hosts changes.

When additional IP addresses are attached to the server, they are added to `/etc/network/interfaces` like
ipv4 65.21.67.71 and ipv6 2a01:4f9:3081:51ec::102 below.

```
auto enp5s0
iface enp5s0 inet static
  address 65.21.67.73
  netmask 255.255.255.192
  gateway 65.21.67.65
  # route 65.21.67.64/26 via 65.21.67.65
  up route add -net 65.21.67.64 netmask 255.255.255.192 gw 65.21.67.65 dev enp5s0
  # BEGIN code.forgejo.org
  up ip addr add 65.21.67.71/32 dev enp5s0
  up nft -f /home/debian/code.nftables
  down ip addr del 65.21.67.71/32 dev enp5s0
  # END code.forgejo.org

iface enp5s0 inet6 static
  address 2a01:4f9:3081:51ec::2
  netmask 64
  gateway fe80::1
  # BEGIN code.forgejo.org
  up ip -6 addr add 2a01:4f9:3081:51ec::102/64 dev enp5s0
  down ip -6 addr del 2a01:4f9:3081:51ec::102/64 dev enp5s0
  # END code.forgejo.org
```

#### Port forwarding

Forwarding a port to an LXC container can be done with `/home/debian/code.nftables` for
the public IP of code.forgejo.org (65.21.67.71) to the private IP of the `code` LXC container:

```
add table ip code;
flush table ip code;
add chain ip code prerouting {
  type nat hook prerouting priority 0;
  policy accept;
  ip daddr 65.21.67.71 tcp dport { ssh } dnat to 10.6.83.195;
};
```

with `nft -f /root/code.nftables`.

#### Containers

- `fogejo-code` on hetzner02

  Dedicated to https://code.forgejo.org

  - Docker enabled
  - upgrades checklist:
    - `ssh -t debian@hetzner02.forgejo.org lxc-helpers.sh lxc_container_run forgejo-code -- sudo --user debian bash`
      ```sh
      emacs /home/debian/run-forgejo.sh # change the `image=`
      docker stop forgejo
      ```
    - `ssh -t debian@hetzner02.forgejo.org sudo /etc/cron.daily/backup-forgejo-code`
    - `ssh -t debian@hetzner02.forgejo.org lxc-helpers.sh lxc_container_run forgejo-code -- sudo --user debian bash`
      ```sh
      docker rm forgejo
      bash -x /home/debian/run-forgejo.sh
      docker logs -n 200 -f forgejo
      ```
  - Rotating 30 days backups happen daily `/etc/cron.daily/forgejo-code-backup.sh`
  - Add code.forgejo.org to the forgejo.org SPF record

- `forgejo-next` on hetzner02

  Dedicated to https://next.forgejo.org

  - Docker enabled
  - `/etc/cron.hourly/forgejo-upgrade` runs `/home/debian/run-forgejo.sh > /home/debian/run-forgejo-$(date +%d).log`
  - When a new major version is published (8.0 for instance) `run-forgejo.sh` must be updated with it
  - Reset everything
    ```sh
    docker stop forgejo
    docker rm forgejo
    sudo rm -fr /srv/forgejo.old
    sudo mv /srv/forgejo /srv/forgejo.old
    bash -x /home/debian/run-forgejo.sh
    ```
  - `/home/debian/next.nftables`
    ```
    add table ip next;
    flush table ip next;
    add chain ip next prerouting {
      type nat hook prerouting priority 0;
      policy accept;
      ip daddr 65.21.67.65 tcp dport { 2020 } dnat to 10.6.83.213;
    };
    ```
  - Add to `iface enp5s0 inet static` in `/etc/network/interfaces`
    ```
    up nft -f /home/debian/next.nftables
    ```

  ```
  - `/etc/nginx/sites-available/next.forgejo.org` same as `/etc/nginx/sites-available/code.forgejo.org`

  ```

- `forgejo-v7` on hetzner02

  Dedicated to https://v7.next.forgejo.org

  - Docker enabled
  - `/etc/cron.hourly/forgejo-upgrade` runs `/home/debian/run-forgejo.sh > /home/debian/run-forgejo-$(date +%d).log`
  - Reset everything
    ```sh
    docker stop forgejo
    docker rm forgejo
    sudo rm -fr /srv/forgejo.old
    sudo mv /srv/forgejo /srv/forgejo.old
    bash -x /home/debian/run-forgejo.sh
    ```
  - `/home/debian/v7.nftables`
    ```
    add table ip v7;
    flush table ip v7;
    add chain ip v7 prerouting {
      type nat hook prerouting priority 0;
      policy accept;
      ip daddr 65.21.67.65 tcp dport { 2070 } dnat to 10.6.83.179;
    };
    ```
  - Add to `iface enp5s0 inet static` in `/etc/network/interfaces`
    ```
    up nft -f /home/debian/v7.nftables
    ```

  ```
  - `/etc/nginx/sites-available/v7.forgejo.org` same as `/etc/nginx/sites-available/code.forgejo.org`

  ```

- `static-pages` on hetzner02

  See [the static pages documenation](../static-pages/) for more information.

  - Unprivileged

- `runner-forgejo-helm` on hetzner03

  Dedicated to https://codeberg.org/forgejo-contrib/forgejo-helm and running from an ephemeral disk

## Uberspace

The website https://forgejo.org is hosted at
https://uberspace.de/. The https://codeberg.org/forgejo/website/ CI
has credentials to push HTML pages there.

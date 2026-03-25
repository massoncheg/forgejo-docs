---
title: 'Installation from packaging'
license: 'CC-BY-SA-4.0'
---

### NixOS

A [`forgejo-runner`](https://search.nixos.org/packages?channel=unstable&show=forgejo-runner&type=packages&query=forgejo-runner) package is available for Nix.
As NixOS service module [`services.gitea-actions-runner.*`](https://search.nixos.org/options?channel=unstable&type=options&query=services.gitea-actions-runner) can be used.

If application containers are to be used (Docker or Podman), one of `virtualisation.docker.enable` or `virtualisation.podman.enable` must also be set to `true`.

An example service definition might look like this:

```nix
services.gitea-actions-runner = {
  package = pkgs.forgejo-runner;
  instances.my-forgejo-instance = {
    enable = true;
    name = "my-forgejo-runner-01";
    token = "<registration-token>";
    url = "https://code.forgejo.org/";
    labels = [
      "node-22:docker://node:22-bookworm"
      "nixos-latest:docker://nixos/nix"
    ];
    settings = { ... };
  };
```

The runner configuration can be specified in `services.gitea-actions-runner.instances.<instance>.settings` as per [Configuration](../../configuration/).

IPv6 support is not enabled by default for docker. The following snippet enables this.

```nix
virtualisation.docker = {
  daemon.settings = {
    fixed-cidr-v6 = "fd00::/80";
    ipv6 = true;
  };
};
```

If you would like to use docker runners in combination with [cache actions](#cache-configuration), be sure to add docker bridge interfaces "br-\*" to the firewalls' trusted interfaces:

```nix
networking.firewall.trustedInterfaces = [ "br-+" ];
```

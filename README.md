# jackett
A docker image for the torznab proxy Jackett

En cours de dev

[hub]: https://hub.docker.com/r/loxoo/jackett
[mbdg]: https://microbadger.com/images/loxoo/jackett
[git]: https://github.com/triptixx/jackett
[actions]: https://github.com/triptixx/jackett/actions

# [loxoo/jackett][hub]
[![Layers](https://images.microbadger.com/badges/image/loxoo/jackett.svg)][mbdg]
[![Latest Version](https://images.microbadger.com/badges/version/loxoo/jackett.svg)][hub]
[![Git Commit](https://images.microbadger.com/badges/commit/loxoo/jackett.svg)][git]
[![Docker Stars](https://img.shields.io/docker/stars/loxoo/jackett.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/loxoo/jackett.svg)][hub]
[![Build Status](https://github.com/triptixx/jackett/workflows/docker%20build/badge.svg)][actions]

## Usage

```shell
docker run -d \
    --name=srvjackett \
    --restart=unless-stopped \
    --hostname=srvjackett \
    -p 9117:9117 \
    -v $PWD/config:/config \
    loxoo/jackett
```

## Environment

- `$SUID`         - User ID to run as. _default: `921`_
- `$SGID`         - Group ID to run as. _default: `921`_
- `$TZ`           - Timezone. _optional_

## Volume

- `/config`       - Server configuration file location.

## Network

- `9117/tcp`      - WebUI.

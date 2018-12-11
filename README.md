# Time Machine

This is a Docker container for self hosting a [Time Machine](https://en.wikipedia.org/wiki/Time_Machine_(macOS)) backup server.

## Getting Started

Quickstart:
```
docker run -h timemachine --name timemachine --restart=always -d -v /<external_volume>:/timemachine -it -p 548:548 -p 636:636 --ulimit nofile=65536:65536 pheonix991/timemachine:latest
```

### Setup


### Step 1: Add user

Everything from here on is only to be done once for setup.

To add a user, run:

```
$ docker run -it --rm -v /storage/docker/timemachine/data:/timemachine -v /storage/docker/timemachine/config:/config -p 548:548 -p 636:636 --ulimit nofile=65536:65536 pheonix991/timemachine:alpine USERNAME PASSWORD VOL_NAME VOL_ROOT [VOL_SIZE_MB]
```

Or, if you want to add a user with a specific UID/GID, use the following format:

```
$ docker exec timemachine add-account -i 1000 -g 1000 USERNAME PASSWORD VOL_NAME VOL_ROOT [VOL_SIZE_MB]
```

But take care that:
* `VOL_NAME` will be the name of the volume shown on your OSX as the network drive
* `VOL_ROOT` should be an absolute path, preferably a sub-path of `/timemachine` (e.g., `/timemachine/backup`), so it will be stored in the according sub-path of your external volume.
* `VOL_SIZE_MB` is an optional parameter. It indicates the max volume size for that user.

### Step 2: `docker run`

```
docker run -h timemachine --name timemachine --restart=always -d -v /<external_volume>:/timemachine /<external_volume2>:/config -it -p 548:548 -p 636:636 --ulimit nofile=65536:65536 pheonix991/timemachine:alpine
```

### Step 3: Enable Auto Discovery(OPTIONAL)

Avahi daemon is commonly used to help your computers to find the services provided by a server.

Avahi isn't built into this Docker image because, due to Docker's networking limitations, Avahi can't spread it's messages to announce the services.

**If you want to enable this feature, you can install Avahi daemon on your host** following these steps (Ubuntu version):

* Install `avahi-daemon`: run `sudo apt-get install avahi-daemon avahi-utils`
* Copy the file from `avahi/nsswitch.conf` to `/etc/nsswitch.conf`
* Copy the service description file from `avahi/afpd.service` to `/etc/avahi/services/afpd.service`
* Restart Avahi's daemon: `sudo /etc/init.d/avahi-daemon restart`


### Step 4 - Configure Your Firewall

Make sure

* your server can receive traffic on port `548` and `636` (e.g., `ufw allow 548`, (`636` respectively)).

* your Mac allows outgoing connections (Little Snitch?)



### Step 5 - Start Using It

To start using it, follow these steps:

* If you use Avahi, open **Finder**, go to **Shared** and connect to your server with your new username and password.

* Alternatively (or if you don't use Avahi) from **Finder** press **CMD-K** and type `afp://your-server` where `your-server` can be your server's name or IP address (e.g., `afp://my-server` or `afp://192.168.0.5`).

* Go to **System Preferences**, and open **Time Machine** settings.

* Open **Add or Remove Backup Disk...**

* Select your new volume.

## Container details
This container is built as a two stage build.  First stage for compiling  [netatalk-debian](https://github.com/adiknoth/netatalk-debian), second stage for the running application.

## Versioning

1.0.0 - Initial build.

## Acknowledgments

* Rebuild of [odarriba's container](https://github.com/odarriba/docker-timemachine).  Also borrowed documentation.
* Built with help from [TechsMix' guide](https://techsmix.net/timemachine-backups-debian-8-jessi/).
* Compiled netatalk from [netatalk-debian](https://github.com/adiknoth/netatalk-debian).

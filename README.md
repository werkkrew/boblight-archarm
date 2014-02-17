Boblight for Arch Linux ARM / Raspberry Pi
================

Overview
--------

This is my personal edit of the original boblight software which can be found at: https://code.google.com/p/boblight/

I updated the v4l client code to work with the newer ffmpeg (>0.8) libraries provided in Arch Linux.

Added some additional optimizations from [Speedy1985's Boblight repository](https://github.com/Speedy1985/boblightd-for-raspberry).  This code means that using the standard boblight.conf will no longer work and you must use 3 character naming for lights as per the example boblight.conf inlcuded here.

I have also fixed a few other V4L related bugs as reported on the [boblight issues list](https://code.google.com/p/boblight/issues/detail?id=49).

Integrated makeboblight.sh configuration helper script as per [enchancement issue 24](https://code.google.com/p/boblight/issues/detail?id=24)

Installing
----------

Assuming you are starting with a base image of Arch Linux for Raspberry Pi (ArchArm) you will need to install the following dependencies using Pacman to compile this code:

git, gcc, make, libx11, libxrender, portaudio, libxext, mesa, glu, ffmpeg

This can be done with the following command:

`pacman -Sy git gcc make libx11 libxrender portaudio libxext mesa glu ffmpeg bc`

To install: `./configure && make && make install`

If you want v4l support use `./configure --with-v4l`

After installing it create a boblight.conf in /etc as per the official documentation: [Boblight Config](https://code.google.com/p/boblight/wiki/boblightconf)

Create a new ld config file in /etc/ld.so.conf.d/ as usr-local.conf and add `/usr/local/lib` to it.

Run `ldconfig`

Create a systemd service for the boblight daemon if you are running the damon on this Pi, for example:

`vi /usr/lib/systemd/system/boblight.service`

```[Unit]
Description=Boblight Ambient Lighting Daemon
DefaultDependencies=no
After=network.target

[Service]
ExecStart=/usr/local/bin/boblightd
Restart=on-abort

[Install]
WantedBy=multi-user.target
```

`systemctl enable boblight`

`systemctl start boblight`

At this point the boblight daemon and all clients should be working.

Troubleshooting
---------------
If you receive following error after executing make:

g++: internal compiler error: Killed (program cc1plus)
Please submit a full bug report,
with preprocessed source if appropriate.
See <https://github.com/archlinuxarm/PKGBUILDs/issues> for instructions.
Makefile:533: recipe for target 'libboblight_la-boblight_client.lo' failed
make[2]: *** [libboblight_la-boblight_client.lo] Error 1
make[2]: Leaving directory '/root/boblight/boblight-archarm/src'
Makefile:345: recipe for target 'all-recursive' failed
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory '/root/boblight/boblight-archarm'
Makefile:254: recipe for target 'all' failed
make: *** [all] Error 2

increase the memory by adding swap space:

Write virtual swap disk

`dd if=/dev/zero of=/root/swap bs=1M count=512`

Set permissions

`chmod 600 /root/swap`

Setup swap

`mkswap /root/swap`

Activate swap

`swapon /root/swap`

try to compile again: `make && make install`

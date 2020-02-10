# poppins

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with poppins](#setup)
    * [What poppins affects](#what-poppins-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with poppins](#beginning-with-poppins)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Simple usage: defining the poppins::host resource](#poppins::host)
    * [Hiera integration](#hiera-integration)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module takes care of configuring your backups using Poppins, a PHP script
that uses rsync to copy (pull) files to your backup machine and creates a 
rotating scheme of incremental snapshots. Works on Linux and some Solaris
variants.

## Module Description

Uses an exported resource poppins::host to designate the host(s) which need to
be backed up. On your backup machine, you would include the "poppins" class to
configure everything that's needed for an automated backup of these hosts. At a
minimum, you need to list the mounted file systems or directories you want to
back up and a ZFS file system to back up to (see below). 

The file system in question will be created automatically, Poppins will be installed, and configuration file for each backup job will be generated and scheduled as a cron job.

## Setup

### What poppins affects

On the host that will be backed up, information is gathered such as the hostname of ip address of the machine. 

On the backup machine:

    * A Mercurial repository will be created in /opt/poppins containing the
      latest edition of poppins
    * Configuration files for each backup job will be created in
      /root/poppins/config, called <hostname>.poppins.ini
    * /usr/bin/poppins will be symlinked to /opt/poppins/init.php
    * a ZFS file system will be created per backup job; this needs to be a
      child file system of an existing zpool
    * Log files will be put in /root/poppins/logs, per backup job as well as a
      poppins.log file containing one line per job ran (=Poppins functionality)

The cron job will be silent (log files contain full output), except for some
messages on stdout, which ideally should indicate a malfunctioning. 

### Setup Requirements

Poppins can backup to any host and use directories containing the snapshots
with hardlinked files, where unchanged files are hardlinked to the same file in
the older snapshots. It can also use the snapshotting features of BTRFS or ZFS.
This Puppet module, however, only supports ZFS at the moment (on OpenIndiana as
well as on Linux using zfsonlinux; it probably works on Oracle Solaris as
well). 

Make sure SSH server and client are compatible. On OpenIndiana, you need to
install openssh using [OpenCSW](http://www.opencsw.org).

Poppins presumes a functioning passwordless (root) login from your backup
server to your host, using public/private key pairs. The puppet resource
ssh\_authorized\_key can be a great help for this.

You will need to install PHP (command line), rsync on both backup server and
backed up hosts, an SSH server on the hosts and client on the server.
Unfortunately, the PHP packages for OpenIndiana and OpenCSW, at the moment, are
too old to run Poppins (5.3.3). We have not yet come up with a more user
friendly solution than downloading and compiling PHP yourself, then symlinking
the cli binary from /usr/bin. 

## Usage

### Simple usage: defining the poppins::host resource

On your backed up host, this is an example resource you could use:

    poppins::host { "$::hostname": 
	zfs               => backups-zpool/poppins-filesystem/homeboxes,
    }

The backups will thus end up in
/backups-zpool/poppins-filesystem/homeboxes/your-computers-hostname

In a default configuration, this will back up your /, /boot, /var and /home
file systems; in case you don't have separate file systems for these, they will
actually be backed up twice, so you might want to customise that :-)

A slightly more elaborate configuration could be:

    poppins::host { "$::hostname": 
	zfs         => backups-zpool/poppins-filesystem/homeboxes,
	included    =>  { "/" => "root", "/home" => "home" },
	excluded    =>   { "/" => "/tmp" },
    }

Other parameters:

    * $remote\_host: will be used as host name to which to connect; you could
      use $::ipaddress for example;
    * $hostdir\_name: by default: $::hostname; this will become the name of the
      zfs file system below your the file system you specified in $zfs;
    * hour: affects start time of the cron job;
    * minute: ...
    * pre\_backup\_script: will be executed remotely before the backup, useful
      for applications which do not like live backups of their data your zfs
      file system names
    * mysql\_enabled and mysql\_configdirs: enables backing up of MySQL
      databases; see Poppins documentation.

### Hiera integration

Instead of specifying your sources directly as resources, you can instead just
include the `poppins::client` class, which will pick up the values
automatically from hiera. Define the parameter "hosts" to the poppins class and 
Hiera will work its magic:

in common.yaml:

```yaml
poppins::hosts
    "%{::clientcert}":
        zfs: "backups-zpool/poppins-filesystem/servers"
```

in kids.yaml:

```yaml
poppins::client::hosts
    "%{::clientcert}":
        zfs: "backups-zpool/poppins-filesystem/kidscomputers"
        hour: "20"
```

in nodes/myproxyserver.yaml:

```yaml
poppins::client::hosts
    "%{::clientcert}":
        included:
            /: "root"
            /home: "home"
            /var/spool/squid: "squid"

```

Thus, your cron jobs and config file will have recognizeable names, and you can
use hiera's inheritance features.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Tested using Puppet 3.6 and 4.10 on Linux (Debian 6-9, Red Hat 6-7) and OpenIndiana
(151a9) both as backup server and as client machine.

## Development

## Release Notes/Contributors/Etc 

Written by Frank Van Damme. See Mercurial log for changes.

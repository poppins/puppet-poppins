# == Class: poppins
#
# Full description of class poppins here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { poppins:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class poppins::server (
    $poppinstag      = $poppins::params::poppinstag,
    $poppins_version = $poppins::params::poppins_version,
) inherits poppins::params {
    # we need: 
    # * poppins sources repo
    # * directory for config files and logs
    file { "$::poppins::params::maindir": 
        ensure => directory,
    }
    file { "$::poppins::params::logdir": 
        ensure => directory,
    }
    file { "$::poppins::params::configdir": 
        ensure       => directory,
        purge        => true,
        recurse      => true,
        recurselimit => 1,
    }

    vcsrepo { "/opt/poppins":
        ensure   => "present",
        provider => git,
        revision => $poppins_version,
        source   => "https://github.com/poppins/poppins",
    }

    file { "$executable":
        ensure => link,
        target => "/opt/poppins/init.php",
    }

    # realize all collected poppins::host resources and write a config file
    # create a cron job

    Poppins::Configfile  <<| tag == "$poppinstag" |>>
    Cron <<| tag == "$poppinstag" |>>
    Zfs <<| tag == "$poppinstag" |>>
}

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
class poppins (
    $version = "stable",
) inherits poppins::params {
    # nodig: 
    # poppins repo
    # directory voor de config files en de logs
    file { "$::poppins::params::maindir": 
	ensure => directory,
    }
    file { "$::poppins::params::logdir": 
	ensure => directory,
    }
    file { "$::poppins::params::configdir": 
	ensure => directory,
    }

    vcsrepo { "/opt/poppins":
	ensure   => "present", 
	provider => hg,
	revision => "default",
	source   => "https://bitbucket.org/poppins/poppins",
	require  => Class['php'],
    }
    file { "/usr/bin/poppins":
	ensure => link,
	target => "/opt/poppins/init.php",
    }
    # hier realizen we al de verzamelde poppins::hosts en schrijven een config
    # file en een cronjob weg. voorlopig parametrerene we niets. 
    Poppins::Configfile  <<|  |>>
    Cron <<| tag == "poppins" |>>
    Zfs <<| tag == "poppins" |>>
}

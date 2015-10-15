define poppins::host (
    $included =  { 
	"/"         => "root",
	"/var"      => "var",
	"/boot"     => "boot",
	"/home"     => "home",
    },
    $excluded     =  { "/" => "/tmp" },
    $zfs          = "backups/poppins/server",
    $hostdir_name = $::hostname,
    $remote_host  = $::ipaddress,
    $ensure       = present,
)  {
    #$configdir=params_lookup(configdir)
    include poppins::params
    $configdir = $::poppins::params::configdir
    $configfile_path = "$configdir/$hostdir_name.poppins.ini"
    notify { "configfile path: $configfile_path": }
    @@cron { "poppins-$name":
	command => "PATH=/usr/bin:/bin:/sbin /usr/bin/poppins -c \"$configfile_path\"",
	user    => root,
	hour    => 17,
	minute  => 10,
	tag     => poppins,
	ensure  => $ensure,
    }
    @@poppins::configfile { "$configfile_path":
	included     => $included,
	excluded     => $excluded,
	hostdir_name => $hostdir_name,
	remote_host  => $remote_host,
	rootdir      => "/$zfs",
	logdir       => "$::poppins::params::logdir",
	ensure       => $ensure,
    }
    @@zfs { "$zfs/$hostdir_name": 
	ensure => present,
	tag     => poppins,
    }
    @@zfs { "$zfs/$hostdir_name/rsync.zfs": 
	ensure => present,
	tag     => poppins,
    }
    if ! defined(Zfs["$zfs"]) {
	@@zfs { "$zfs": 
	    ensure => present,
	    tag     => poppins,
	}
    }

}

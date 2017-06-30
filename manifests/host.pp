define poppins::host (
    $zfs       = "backups/poppins/server",
    $included =  { 
	"/"         => "root",
	"/var"      => "var",
	"/boot"     => "boot",
	"/home"     => "home",
    },
    $excluded         =  { "/" => "tmp" },
    $hostdir_name     = $::hostname,
    $remote_host      = $::ipaddress,
    $remote_user      = 'root',
    $snapshots = {
	"incremental" => 4,
	"1-daily"     => 7,
	"1-weekly"    => 4,
	"1-monthly"   => 3,
	"1-yearly"    => 1,
    },
    $ensure           = present,
    $pre_backup_script = "",
    $mysql_enabled    = false,
    $mysql_configdirs = undef,
    $hour             = 0,
    $minute           = 0,
)  {
    #$configdir=params_lookup(configdir)
    include poppins::params
    $configdir = $::poppins::params::configdir
    $configfile_path = "$configdir/$hostdir_name.poppins.ini"
    validate_hash($included)
    validate_hash($excluded)
    validate_hash($snapshots)
    notify{"poppins config named $name,": }
    @@cron { "poppins-$name":
	command => "PATH=/opt/csw/bin:/usr/gnu/bin:/usr/bin:/bin:/usr/sbin:/sbin ionice -n 7 /usr/bin/poppins -t puppet -c \"$configfile_path\" >/dev/null",
	user    => root,
	hour    => $hour,
	minute  => $minute,
	tag     => poppins,
	ensure  => $ensure,
    }
    poppins::configfile { "$configfile_path":
	included          => $included,
	excluded          => $excluded,
	hostdir_name      => $hostdir_name,
	remote_host       => $remote_host,
	remote_user       => $remote_user,
	snapshots         => $snapshots,
	rootdir           => "/$zfs",
	logdir            => "$::poppins::params::logdir",
	ensure            => $ensure,
	mysql_enabled     => $mysql_enabled,
	mysql_configdirs  => $mysql_configdirs,
	pre_backup_script => $pre_backup_script,
    }
    @@zfs { "$zfs/$hostdir_name": 
	ensure => present,
	tag     => poppins,
    }
    @@zfs { "$zfs/$hostdir_name/rsync.zfs": 
	ensure => present,
	tag     => poppins,
    }
}

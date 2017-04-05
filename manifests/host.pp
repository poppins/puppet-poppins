define poppins::host (
    $zfs               = $poppins::params::zfs,
    $included          = $poppins::params::included,
    $excluded          = $poppins::params::excluded,
    $remote_host       = $poppins::params::remote_host,
    $ensure            = $poppins::params::ensure,
    $pre_backup_script = $poppins::params::pre_backup_script,
    $mysql_enabled     = $poppins::params::mysql_enabled,
    $mysql_configdirs  = $poppins::params::mysql_configdirs,
    $hour              = $poppins::params::hour,
    $minute            = $poppins::params::minute,
    $hostdir_name      = $poppins::params::hostdir_name,
)  {

    include poppins::params

    $configdir = $::poppins::params::configdir
    $configfile_path = "$configdir/$name.poppins.ini"

    @@cron { "poppins-$name":
	command => "PATH=/opt/csw/bin:/usr/gnu/bin:/usr/bin:/bin:/usr/sbin:/sbin ionice -n 7 /usr/bin/poppins -c \"$configfile_path\" >/dev/null",
        user    => root,
        hour    => $hour,
        minute  => $minute,
        tag     => poppins,
        ensure  => $ensure,
    }
    @@poppins::configfile { "$configfile_path":
        included         => $included,
        excluded         => $excluded,
        hostdir_name     => $hostdir_name,
        remote_host      => $remote_host,
        rootdir          => "/$zfs",
        logdir           => "$::poppins::params::logdir",
        ensure           => $ensure,
        mysql_enabled    => $mysql_enabled,
        mysql_configdirs => $mysql_configdirs,
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

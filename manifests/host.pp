define poppins::host (
    $zfs               = $poppins::params::zfs,
    $included          = $poppins::params::included,
    $excluded          = $poppins::params::excluded,
    $remote_host       = $poppins::params::remote_host,
    $remote_user       = $poppins::params::remote_user,
    $snapshots         = $poppins::params::snapshots,
    $ensure            = $poppins::params::ensure,
    $pre_backup_script = $poppins::params::pre_backup_script,
    $mysql_enabled     = $poppins::params::mysql_enabled,
    $mysql_configdirs  = $poppins::params::mysql_configdirs,
    $hour              = $poppins::params::hour,
    $minute            = $poppins::params::minute,
    $hostdir_name      = $poppins::params::hostdir_name,
    $poppinstag        = $poppins::client::poppinstag,
)  {

    include poppins::params

    $configdir = $::poppins::params::configdir
    $configfile_path = "$configdir/$name.poppins.ini"

    validate_hash($included)
    validate_hash($excluded)
    validate_hash($snapshots)
    notify{"poppins config named $name,": }
    @@cron { "poppins-$name":
        command => "PATH=/opt/csw/bin:/usr/gnu/bin:/usr/bin:/bin:/usr/sbin:/sbin ionice -n 7 /usr/bin/poppins -t puppet -c \"$configfile_path\" >/dev/null",
        user    => root,
        hour    => $hour,
        minute  => $minute,
        tag     => $poppinstag,
        ensure  => $ensure,
    }
    @@poppins::configfile { "$configfile_path":
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
        tag               => $poppinstag,
    }
    @@zfs { "$zfs/$hostdir_name": 
        ensure => present,
        tag     => $poppinstag,
    }
    @@zfs { "$zfs/$hostdir_name/rsync.zfs": 
        ensure => present,
        tag     => $poppinstag,
    }
}

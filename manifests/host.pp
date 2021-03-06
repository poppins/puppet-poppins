define poppins::host (
    $zfs                  = $poppins::params::zfs,
    $included             = $poppins::params::included,
    $excluded             = $poppins::params::excluded,
    $remote_ssh_port      = $poppins::params::remote_ssh_port,
    $remote_host          = $poppins::params::remote_host,
    $remote_user          = $poppins::params::remote_user,
    $remote_retry_count   = $poppins::params::remote_retry_count,
    $remote_retry_timeout = $poppins::params::remote_retry_timeout,
    $rsync_retry_count    = $poppins::params::rsync_retry_count,
    $rsync_retry_timeout  = $poppins::params::rsync_retry_timeout,
    $snapshots            = $poppins::params::snapshots,
    $ensure               = $poppins::params::ensure,
    $pre_backup_script    = $poppins::params::pre_backup_script,
    $pre_backup_onfail    = $poppins::params::pre_backup_onfail,
    $post_backup_script   = $poppins::params::post_backup_script,
    $backup_onfail        = $poppins::params::backup_onfail,
    $mysql_enabled        = $poppins::params::mysql_enabled,
    $mysql_configdirs     = $poppins::params::mysql_configdirs,
    $mysql_output         = $poppins::params::mysql_output,
    $hour                 = $poppins::client::hour,
    $minute               = $poppins::client::minute,
    $hostdir_name         = $poppins::params::hostdir_name,
    $poppinstag           = $poppins::client::poppinstag,
    $timestamps           = $poppins::client::timestamps,
    $logdir               = $poppins::client::logdir,
    $executable           = $poppins::client::executable,
)  {

    include poppins::params

    $configdir = $::poppins::params::configdir
    $configfile_path = "$configdir/$name.poppins.ini"

    validate_hash($included)
    validate_hash($excluded)
    validate_hash($snapshots)

    @@cron { "poppins-$name":
        command => "PATH=/opt/csw/bin:/usr/gnu/bin:/usr/bin:/bin:/usr/sbin:/sbin ionice -n 7 \"$executable\" -t puppet -c \"$configfile_path\" >/dev/null",
        user    => root,
        hour    => $hour,
        minute  => $minute,
        tag     => $poppinstag,
        ensure  => $ensure,
    }

    @@poppins::configfile { "$configfile_path":
        included             => $included,
        excluded             => $excluded,
        hostdir_name         => $hostdir_name,
        remote_ssh_port      => $remote_ssh_port,
        remote_host          => $remote_host,
        remote_user          => $remote_user,
        remote_retry_count   => $remote_retry_count,
        remote_retry_timeout => $remote_retry_timeout,
        rsync_retry_count    => $rsync_retry_count,
        rsync_retry_timeout  => $rsync_retry_timeout,
        snapshots            => $snapshots,
        rootdir              => "/$zfs",
        logdir               => $logdir,
        ensure               => $ensure,
        mysql_enabled        => $mysql_enabled,
        mysql_configdirs     => $mysql_configdirs,
        mysql_output         => $mysql_output,
        pre_backup_script    => $pre_backup_script,
        pre_backup_onfail    => $pre_backup_onfail,
        post_backup_script   => $post_backup_script,
        backup_onfail        => $backup_onfail,
        tag                  => $poppinstag,
        timestamps           => $timestamps,
    }

    if ( $ensure == present ){
	@@zfs { "$zfs/$hostdir_name": 
	    ensure => present,
	    tag    => $poppinstag,
	}
	@@zfs { "$zfs/$hostdir_name/rsync.zfs": 
	    ensure => present,
	    tag    => $poppinstag,
	}
    }
}

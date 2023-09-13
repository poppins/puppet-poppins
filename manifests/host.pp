define poppins::host (
    String $zfs                             = $poppins::params::zfs,
    Hash $included                          = $poppins::params::included,
    Hash $excluded                          = $poppins::params::excluded,
    Integer $remote_ssh_port                = $poppins::params::remote_ssh_port,
    String $remote_host                     = $poppins::params::remote_host,
    String $remote_user                     = $poppins::params::remote_user,
    Integer $remote_retry_count             = $poppins::params::remote_retry_count,
    Integer $remote_retry_timeout           = $poppins::params::remote_retry_timeout,
    Integer $rsync_retry_count              = $poppins::params::rsync_retry_count,
    Integer $rsync_retry_timeout            = $poppins::params::rsync_retry_timeout,
    Hash[String, Integer] $snapshots        = $poppins::params::snapshots,
    String $ensure                          = $poppins::params::ensure,
    String $pre_backup_script               = $poppins::params::pre_backup_script,
    String $pre_backup_onfail               = $poppins::params::pre_backup_onfail,
    String $post_backup_script              = $poppins::params::post_backup_script,
    String $backup_onfail                   = $poppins::params::backup_onfail,
    Boolean $mysql_enabled                  = $poppins::params::mysql_enabled,
    Variant[String,Undef] $mysql_configdirs = $poppins::params::mysql_configdirs,
    String $mysql_output                    = $poppins::params::mysql_output,
    Integer $hour                           = $poppins::client::hour,
    Integer $minute                         = $poppins::client::minute,
    String $hostdir_name                    = $poppins::params::hostdir_name,
    String $poppinstag                      = $poppins::client::poppinstag,
    Boolean $timestamps                     = $poppins::client::timestamps,
    String $logdir                          = $poppins::client::logdir,
    String $executable                      = $poppins::client::executable,
)  {

    include poppins::params

    $configdir = $::poppins::params::configdir
    $configfile_path = "$configdir/$name.poppins.ini"

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

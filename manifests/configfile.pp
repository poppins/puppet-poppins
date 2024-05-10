# Resource to install backup job config file
define poppins::configfile (
    $included,
    $excluded,
    $logdir,
    $remote_ssh_port,
    $remote_retry_count,
    $remote_retry_timeout,
    $remote_host,
    $remote_user,
    Boolean $ipv6,
    $rsync_retry_count,
    $rsync_retry_timeout,
    $snapshots,
    $hostdir_name,
    $rootdir,
    $ensure,
    $mysql_enabled,
    $mysql_output,
    $timestamps,
    $mysql_configdirs=undef,
    $pre_backup_script="",
    $pre_backup_onfail="",
    $post_backup_script="",
    $backup_onfail="",
) {
    file { $name:
        ensure  => $ensure,
        content => template ("${module_name}/poppins.ini.erb"),
        tag     => "poppins_config",
    }
}

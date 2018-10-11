define poppins::configfile (
    $included, 
    $excluded, 
    $logdir, 
    $remote_host, 
    $remote_user, 
    $snapshots,
    $hostdir_name, 
    $rootdir,
    $ensure, 
    $mysql_enabled, 
    $mysql_output, 
    $mysql_configdirs=undef, 
    $pre_backup_script="",
    $pre_backup_onfail="",
    $post_backup_script="",
    $backup_onfail="",
    $timestamps,
) { 
    file { "$name":
	content => template ("$module_name/poppins.ini.erb"),
	tag     => "poppins_config",
    }
}


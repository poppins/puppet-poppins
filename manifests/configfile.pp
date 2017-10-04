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
    $mysql_configdirs=undef, 
    $pre_backup_script=""
) { 
    file { "$name":
	content => template ("$module_name/poppins.ini.erb"),
	tag     => "poppins_config",
    }
}


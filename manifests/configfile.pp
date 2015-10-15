define poppins::configfile (
    $included, $excluded, $logdir, $remote_host, $hostdir_name, $rootdir, $ensure
) { 
    file { "$name":
	content => template ("$module_name/poppins.ini.erb")
    }
}


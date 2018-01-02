class poppins::params {
    $maindir = "/root/poppins.d"
    $logdir = "/root/poppins.d/logs"
    $configdir = "/root/poppins.d/config"
    $zfs       = "backups/poppins/server"
    $included =  { 
	"/"         => "root",
	"/var"      => "var",
	"/boot"     => "boot",
	"/home"     => "home",
    }
    $excluded          =  { "/" => "tmp" }
    $hostdir_name      = $::hostname
    $remote_host       = "$::ipaddress"
    $remote_user      = 'root'
    $snapshots = {
    	"incremental" => 4,
    	"1-daily"     => 7,
    	"1-weekly"    => 4,
    	"1-monthly"   => 6,
    	"6-monthly"   => 2,
	"1-yearly"    => 1,
    }

    $ensure            = present
    $pre_backup_script = ""
    $mysql_enabled     = false
    $mysql_configdirs  = undef
    $hour              = 0
    $minute            = 2
    $poppinstag        = 'default'
}

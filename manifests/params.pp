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
    $excluded          =  { "/" => "/tmp" }
    $hostdir_name      = $::hostname
    $remote_host       = "$::ipaddress"
    $ensure            = present
    $pre_backup_script = ""
    $mysql_enabled     = false
    $mysql_configdirs  = undef
    $hour              = 0
    $minute            = 2
}

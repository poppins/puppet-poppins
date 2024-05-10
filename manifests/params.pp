# Set defaults for main class
class poppins::params {
    $maindir              = "/root/poppins.d"
    $logdir               = "/root/poppins.d/logs"
    $configdir            = "/root/poppins.d/config"
    $zfs                  = "backups/poppins/server"
    $included             =  {
        "/"         => "root",
        "/var"      => "var",
        "/boot"     => "boot",
        "/home"     => "home",
    }
    $excluded             =  { "/" => "tmp" }
    $hostdir_name         = $facts[networking][hostname]
    $remote_ssh_port      = 22
    $remote_host          = $facts[networking][ip]
    $remote_user          = 'root'
    $ipv6                 = false
    $remote_retry_count   = 0
    $remote_retry_timeout = 10
    $rsync_retry_count    = 1
    $rsync_retry_timeout  = 10
    $snapshots = {
        "incremental" => 4,
        "1-daily"     => 7,
        "1-weekly"    => 4,
        "1-monthly"   => 6,
        "6-monthly"   => 2,
        "1-yearly"    => 1,
    }

    $ensure               = present
    $pre_backup_script    = ""
    $pre_backup_onfail    = abort
    $backup_onfail        = abort
    $post_backup_script   = ""
    $mysql_enabled        = false
    $mysql_configdirs     = undef
    $mysql_output         = 'database'
    $hour                 = 0
    $minute               = 2
    $poppinstag           = 'default'
    $timestamps           = false
    $poppins_version      = 'v0.5'
    $executable           = "/usr/bin/poppins"
}

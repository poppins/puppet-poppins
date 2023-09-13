class poppins::client (
    Hash $hosts = {},
    $poppinstag = $poppins::params::poppinstag,
    $hour       = $poppins::params::hour,
    $minute     = $poppins::params::minute,
    $timestamps = $poppins::params::timestamps,
    $logdir     = $poppins::params::logdir,
    $executable = $poppins::params::executable,
) inherits poppins::params
{
    if $hosts {
        create_resources('poppins::host', $hosts)
    }
}

class poppins::client (
    $hosts = {},
    $poppinstag = $poppins::params::poppinstag,
    $hour       = $poppins::params::hour,
    $minute     = $poppins::params::minute,
) inherits poppins::params 
{ 
    if $hosts {
	create_resources('poppins::host', $hosts)
    }
}

class poppins::client (
    $hosts = {},
    $poppinstag = $poppins::params::poppinstag,
) inherits poppins::params 
{ 
    if $hosts {
	create_resources('poppins::host', $hosts)
    }
}

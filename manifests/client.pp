class poppins::client (
    $hosts = {},
) inherits poppins::params 
{ 
    if $hosts {
	create_resources('poppins::host', $hosts)
    }
}

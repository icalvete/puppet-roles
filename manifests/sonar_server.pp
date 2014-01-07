class roles::sonar_server (

  $repo_scheme   = undef,
  $repo_domain   = undef,
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_path     = undef,
  $repo_resource = undef,
  $plugins       = undef,
  $ldap          = false,
  $ssl           = false

) inherits roles {

  class {'sonar':
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => $repo_port,
    repo_user     => $repo_user,
    repo_pass     => $repo_path,
    repo_path     => $repo_path,
    repo_resource => $repo_resource,
    plugins       => $plugins,
    ldap          => $ldap,
    ssl           => $ssl
  }
}

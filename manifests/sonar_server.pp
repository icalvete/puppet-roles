class roles::sonar_server (

  $repo_scheme   = 'https',
  $repo_domain   = 'repo.smartpurposes.net',
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_path     = false,
  $repo_resource = undef,
  $plugins       = undef,
  $ldap          = false,
  $ssl           = false

) inherits roles {

  if ! $repo_resource {
    fail('repo_resource parameter must be defined')
  }

  class {'sonar':
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => false,
    repo_user     => false,
    repo_pass     => false,
    repo_path     => $repo_path,
    repo_resource => $repo_resource,
    plugins       => $plugins,
    ldap          => $ldap,
    ssl           => $ssl
  }
}

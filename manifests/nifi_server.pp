class roles::nifi_server (

  $version       = undef,
  $repo_scheme   = undef,
  $repo_domain   = undef,
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_resource = undef,

) inherits roles {

  class { 'java':
    distribution => 'jre',
  }

  class {'nifi':
    version       => $version,
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => false,
    repo_user     => false,
    repo_pass     => false,
    repo_path     => $repo_path,
    repo_resource => $repo_resource,
  }
}

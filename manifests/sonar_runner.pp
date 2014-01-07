class roles::sonar_runner (

  $repo_scheme   = undef,
  $repo_domain   = undef,
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_path     = undef,
  $repo_resource = undef,

) inherits roles {

  class {'sonar::runner':
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => $repo_port,
    repo_user     => $repo_user,
    repo_pass     => $repo_path,
    repo_path     => $repo_path,
    repo_resource => $repo_resource,
  }
}

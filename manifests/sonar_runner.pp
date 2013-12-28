class roles::sonar_runner (

  $repo_scheme   = 'https',
  $repo_domain   = 'repo.smartpurposes.net',
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_path     = false,
  $repo_resource = undef,

) inherits roles {

  if ! $repo_resource {
    fail('repo_resource parameter must be defined')
  }

  class {'sonar::runner':
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => false,
    repo_user     => false,
    repo_pass     => false,
    repo_path     => $repo_path,
    repo_resource => $repo_resource,
  }
}

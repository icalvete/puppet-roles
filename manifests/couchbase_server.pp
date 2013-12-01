class roles::couchbase_server (

  $repo_scheme   = 'http',
  $repo_domain   = 'packages.couchbase.com',
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_path     = 'releases/2.1.1',
  $repo_resource = undef

) inherits roles {

  if ! $repo_resource {
    fail('repo_resource parameter must be defined')
  }

  class {'couchbase':
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => false,
    repo_user     => false,
    repo_pass     => false,
    repo_path     => $repo_path,
    repo_resource => $repo_resource
  }
}

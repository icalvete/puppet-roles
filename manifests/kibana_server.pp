class roles::kibana_server (

  $repo_scheme   = 'https',
  $repo_domain   = 'github.com',
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_path     = 'elasticsearch/kibana/archive',
  $repo_resource = 'master.tar.gz'

) inherits roles {

  include roles::apache2_server

  class {'kibana3':
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => $repo_port,
    repo_user     => $repo_user,
    repo_pass     => $repo_pass,
    repo_path     => $repo_path,
    repo_resource => $repo_resource,
    require       => Class['roles::apache2_server']
  }
}

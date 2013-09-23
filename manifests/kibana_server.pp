class roles::kibana_server (

  $repo_scheme   = undef,
  $repo_domain   = undef,
  $repo_port     = undef,
  $repo_user     = undef,
  $repo_pass     = undef,
  $repo_path     = undef,
  $repo_resource = undef

) inherits roles {
  
  include roles::apache2_server
  
  class {'kibana3':
    repo_scheme   => 'https',
    repo_domain   => 'github.com',
    repo_port     => false,
    repo_user     => false,
    repo_pass     => false,
    repo_path     => 'elasticsearch/kibana/archive',
    repo_resource => 'master.tar.gz',
    require  => Class['roles::apache2_server']
  }
}

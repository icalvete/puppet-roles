class roles::elasticsearch_server (

  $repo_scheme   = undef,
  $repo_domain   = undef,
  $repo_port     = undef,
  $repo_user     = undef,
  $repo_pass     = undef,
  $repo_path     = undef,
  $repo_resource = undef

) inherits roles {
  
  class {'elasticsearch':
    repo_scheme   => 'http',
    repo_domain   => 'download.elasticsearch.org',
    repo_port     => false,
    repo_user     => false,
    repo_pass     => false,
    repo_path     => 'elasticsearch/elasticsearch',
    repo_resource => 'elasticsearch-0.90.5.deb'
  }
}

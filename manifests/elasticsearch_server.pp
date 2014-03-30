class roles::elasticsearch_server (

  $repo_scheme   = 'http',
  $repo_domain   = 'download.elasticsearch.org',
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_path     = 'elasticsearch/elasticsearch',
  $repo_resource = 'elasticsearch-1.1.0.deb'

) inherits roles {

  class {'elasticsearch':
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => $repo_port,
    repo_user     => $repo_user,
    repo_pass     => $repo_pass,
    repo_path     => $repo_path,
    repo_resource => $repo_resource
  }
}

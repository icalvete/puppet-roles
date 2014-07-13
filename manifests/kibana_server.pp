class roles::kibana_server (

  $org_domain                = undef,
  $server_alias              = undef,
  $repo_scheme               = 'https',
  $repo_domain               = 'download.elasticsearch.org',
  $repo_port                 = false,
  $repo_user                 = false,
  $repo_pass                 = false,
  $repo_path                 = 'kibana/kibana',
  $repo_resource             = 'kibana-3.1.0.tar.gz',
  $elasticsearch_server      = undef,
  $elasticsearch_server_auth = undef


) inherits roles {

  include roles::apache2_server

  class {'kibana3':
    org_domain                => $org_domain,
    server_alias              => $server_alias,
    repo_scheme               => $repo_scheme,
    repo_domain               => $repo_domain,
    repo_port                 => $repo_port,
    repo_user                 => $repo_user,
    repo_pass                 => $repo_pass,
    repo_path                 => $repo_path,
    repo_resource             => $repo_resource,
    elasticsearch_server      => $elasticsearch_server,
    elasticsearch_server_auth => $elasticsearch_server_auth,
    require                   => Class['roles::apache2_server']
  }
}

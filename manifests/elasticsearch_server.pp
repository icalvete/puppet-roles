class roles::elasticsearch_server (

  $repo_scheme   = 'http',
  $repo_domain   = 'download.elasticsearch.org',
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_path     = 'elasticsearch/elasticsearch',
  $repo_resource = 'elasticsearch-1.1.1.deb',
  $cluster       = undef,
  $jetty         = undef,
  $apache        = undef,
  $server_alias  = undef,
  $kibana_server = undef,
  $template      = undef

) inherits roles {

  realize Package['curl']

  if $apache {

    include roles::apache2_server

    apache2::module { 'proxy':
      require => Class['roles::apache2_server']
    }

    apache2::module { 'proxy_http':
      require => Class['roles::apache2_server']
    }

    $elasticsearch_htpasswd_file = hiera('htpasswd_file')
    $elasticsearch_htpasswd_user = hiera('elasticsearch_user')
    $elasticsearch_htpasswd_pass = hiera('elasticsearch_user_pass')

    htpasswd::user {'elasticsearch_http_basic_user':
      file     => $elasticsearch_htpasswd_file,
      user     => $elasticsearch_htpasswd_user,
      password => $elasticsearch_htpasswd_pass,
      require  => Class['roles::apache2_server']
    }
  }

  class {'elasticsearch':
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => $repo_port,
    repo_user     => $repo_user,
    repo_pass     => $repo_pass,
    repo_path     => $repo_path,
    repo_resource => $repo_resource,
    cluster       => $cluster,
    jetty         => $jetty,
    apache        => $apache,
    server_alias  => $server_alias,
    kibana_server => $kibana_server,
    template      => $template
  }
}

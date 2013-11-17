class roles::rabbitmq_server (

  $repo_scheme   = 'http',
  $repo_domain   = 'www.rabbitmq.com',
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_path     = 'releases/rabbitmq-server/v3.1.5',
  $repo_resource = undef

) inherits roles {

  class {'rabbitmq':
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => false,
    repo_user     => false,
    repo_pass     => false,
    repo_path     => $repo_path,
    repo_resource => $repo_resource
  }
}

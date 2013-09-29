class roles::rabbitmq_server (

  $repo_scheme   = undef,
  $repo_domain   = undef,
  $repo_port     = undef,
  $repo_user     = undef,
  $repo_pass     = undef,
  $repo_path     = undef,
  $repo_resource = undef

) inherits roles {
  
  class {'rabbitmq':
    repo_scheme   => 'http',
    repo_domain   => 'www.rabbitmq.com',
    repo_port     => false,
    repo_user     => false,
    repo_pass     => false,
    repo_path     => 'releases/rabbitmq-server/v3.1.5',
    repo_resource => $repo_resource
  }
}

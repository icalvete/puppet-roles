class roles::logstash_server (

  $ls_type        = undef,
  $ls_type_source = undef,
  $log_dir        = undef,
  $log            = undef,
  $scheme         = undef,
  $domain         = undef,
  $port           = undef,
  $user           = undef,
  $pass           = undef,
  $path           = undef,
  $resource       = undef

) inherits roles {
  
  class {'logstash':
    ls_type        => $ls_type,
    ls_type_source => $ls_type_source,
    log_dir        => $log_dir,
    log            => $log,
    repo_scheme    => 'https',
    repo_domain    => 'logstash.objects.dreamhost.com',
    repo_port      => false,
    repo_user      => false,
    repo_pass      => false,
    repo_path      => 'release',
    repo_resource  => 'logstash-1.2.1-flatjar.jar'
  }
}

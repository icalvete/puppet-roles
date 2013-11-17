class roles::logstash_server (

  $ls_type        = undef,
  $ls_type_source = undef,
  $log_dir        = undef,
  $log            = undef,
  $repo_scheme    = 'https',
  $repo_domain    = 'logstash.objects.dreamhost.com',
  $repo_port      = false,
  $repo_user      = false,
  $repo_pass      = false,
  $repo_path      = 'release',
  $repo_resource  = 'logstash-1.2.1-flatjar.jar',

) inherits roles {

  class {'logstash':
    ls_type        => $ls_type,
    ls_type_source => $ls_type_source,
    log_dir        => $log_dir,
    log            => $log,
    repo_scheme    => $repo_scheme,
    repo_domain    => $repo_domain,
    repo_port      => $repo_port,
    repo_user      => $repo_user,
    repo_pass      => $repo_pass,
    repo_path      => $repo_path,
    repo_resource  => $repo_resource
  }
}

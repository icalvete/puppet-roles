class roles::nifi_server (

  $version                = undef,
  $repo_scheme            = undef,
  $repo_domain            = undef,
  $repo_port              = false,
  $repo_user              = false,
  $repo_pass              = false,
  $repo_resource          = undef,
  $auth                   = undef,
  $keystore_file_source   = undef,
  $keystore_password      = undef,
  $admin                  = undef,
  $truststore_file_source = undef,
  $truststore_password    = undef,

) inherits roles {

  class { 'java':
    distribution => 'jre',
  }

  class {'nifi':
    version                => $version,
    repo_scheme            => $repo_scheme,
    repo_domain            => $repo_domain,
    repo_port              => false,
    repo_user              => false,
    repo_pass              => false,
    repo_path              => $repo_path,
    repo_resource          => $repo_resource,
    auth                   => $auth,
    keystore_file_source   => $keystore_file_source,
    keystore_password      => $keystore_password,
    admin                  => $admin,
    truststore_file_source => $truststore_file_source,
    truststore_password    => $truststore_password
  }
}

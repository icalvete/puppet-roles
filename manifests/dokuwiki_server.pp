class roles::dokuwiki_server (

  $repo_scheme   = 'http',
  $repo_domain   = 'download.dokuwiki.org',
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_path     = 'src/dokuwiki',
  $repo_resource = undef,
  $ldap           = false

) inherits roles {

  include roles::apache2_server

  if $ldap {
    $ldap_host               = hiera('ldap_host')
    $ldap_suffix             = hiera('ldap_suffix')
  }

  class {'dokuwiki':
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => $repo_port,
    repo_user     => $repo_user,
    repo_pass     => $repo_pass,
    repo_path     => $repo_path,
    repo_resource => $repo_resource,
    require       => Class['roles::apache2_server'],
    ldap          => $ldap
  }
}

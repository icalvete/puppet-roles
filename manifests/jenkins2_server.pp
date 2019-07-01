class roles::jenkins2_server (

  $repo_scheme   = 'http',
  $repo_domain   = 'pkg.jenkins-ci.org',
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_resource = undef,
  $ssl           = false,
  $sonar         = false,
  $keystore      = undef,
  $url           = undef

) inherits roles {

  case $::operatingsystem {
    /^(Debian|Ubuntu)$/: {
      $repo_path = 'debian/binary'
    }
    /^(CentOS|RedHat)$/: {
      $repo_path = 'redhat'
    }
    default: {
      fail ("${::operatingsystem} not supported.")
    }
  }

  class {'jenkins2':
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => false,
    repo_user     => false,
    repo_pass     => false,
    repo_path     => $repo_path,
    repo_resource => $repo_resource,
    ssl           => $ssl,
    sonar         => $sonar,
    keystore      => $keystore,
    url           => $url
  }
}

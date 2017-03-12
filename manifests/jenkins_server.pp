class roles::jenkins_server (

  $repo_scheme   = 'http',
  $repo_domain   = 'pkg.jenkins-ci.org',
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_resource = undef,
  $admin_user    = undef,
  $admin_pass    = undef,
  $ldap          = false,
  $ssl           = false,
  $sonar         = false

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

  class {'jenkins':
    repo_scheme   => $repo_scheme,
    repo_domain   => $repo_domain,
    repo_port     => false,
    repo_user     => false,
    repo_pass     => false,
    repo_path     => $repo_path,
    repo_resource => $repo_resource,
    admin_user    => $admin_user,
    admin_pass    => $admin_pass,
    ldap          => $ldap,
    ssl           => $ssl,
    sonar         => $sonar
  }
}

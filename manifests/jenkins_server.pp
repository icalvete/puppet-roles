class roles::jenkins_server (

  $repo_scheme   = 'http',
  $repo_domain   = 'pkg.jenkins-ci.org',
  $repo_port     = false,
  $repo_user     = false,
  $repo_pass     = false,
  $repo_resource = undef,
  $cluster       = false,
  $ldap          = false

) inherits roles {

  if ! $repo_resource {
    fail('repo_resource parameter must be defined')
  }

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
    cluster       => $cluster,
    ldap          => $ldap
  }
}

class roles::puppet_dashboard {
  include roles::apache2_server
  include puppet::dashboard

  Class['roles::apache2_server']->Class['puppet::dashboard']
}

class roles::puppet_dashboard {
  include roles::apache2_server

  class {'puppet::dashboard':
    web_server => true
  }

  Class['roles::apache2_server']->Class['puppet::dashboard']
}

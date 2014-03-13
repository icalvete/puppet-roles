class roles::phpldapadmin_server {

  include roles::apache2_server
  include phpldapadmin

  Class['roles::apache2_server']->Class['phpldapadmin']

  apache2::site{'phpldapadmin.vhost.conf':
    source              => 'phpldapadmin/phpldapadmin.vhost.conf.erb',
    include_from_source => 'phpldapadmin::params',
    require             => Class['roles::apache2_server', 'phpldapadmin']
  }
}

class roles::graphite_server (

  $server_name = undef,
  $timezone    = 'Europe/Madrid'

) {
  include roles::apache2_server

  apache2::module { 'wsgi':
    package => 'libapache2-mod-wsgi',
    require => Class['roles::apache2_server']
  }

  include graphite::params

  class {'graphite':
    gr_web_server     => 'none',
    gr_web_user       => $::graphite::params::apache_web_user,
    gr_web_group      => $::graphite::params::apache_web_group,
    gr_web_servername => $server_name,
    gr_timezone       => $timezone
  }

  apache2::alias{'graphite_alias':
    content => "Alias /graphite ${::graphite::gr_base_dir}/webapp",
    before  => Class['graphite']
  }
  
  apache2::site{'graphite.vhost.conf':
    source              => "${module_name}/graphite/web/apache2/graphite.vhost.conf.erb",
    include_from_source => 'graphite::params',
    require             => Class['roles::apache2_server', 'graphite']
  }
}

class roles::kibana_server (

  $kibana_version = '5.5.2',
  $org_domain                = hiera('org_domain', 'example.net'),
  $kibana_htpasswd_file      = hiera('htpasswd_file', '/etc/apache2/htpasswd'),
  $kibana_htpasswd_user      = hiera('kibana_user', 'kibana'),
  $kibana_htpasswd_pass      = hiera('kibana_pass', 'kibana'),
  $elasticsearch_server      = 'localhost:9200',

) inherits roles {

  include roles::apache2_server

  if ! defined (Apache2::Module['proxy']) {
    apache2::module { 'proxy':
      require =>  Class['roles::apache2_server']
    }
  }

  if ! defined (Apache2::Module['proxy_http']) {
    apache2::module { 'proxy_http':
      require =>  Class['roles::apache2_server']
    }
  }

  htpasswd::user { $kibana_htpasswd_user:
    file     => $kibana_htpasswd_file,
    password => $kibana_htpasswd_pass,
  }

  apache2::site{'kibana_vhost':
    source  => "${module_name}/kibana_server/web/apache2/kibana.vhost.conf.erb",
    require => Class['roles::apache2_server']
  }

  class {'kibana':
    ensure => $kibana_version,
    config => {
      'elasticsearch.url' =>  "http://${elasticsearch_server}",
    }
  }
}

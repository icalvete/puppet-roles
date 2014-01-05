class roles::graphite_server (

  $htpasswd_file = hiera('htpasswd_file'),
  $htpasswd_user = 'graphite',
  $htpasswd_pass = 'gr4ph1t3',
  $amqp_host     = hiera('graphite_amqp_server'),
  $amqp_port     = hiera('graphite_amqp_port'),
  $amqp_user     = hiera('graphite_amqp_user'),
  $amqp_password = hiera('graphite_amqp_pass'),

) {

  include graphite::params

  exec {'graphite_document_root':
    command => "/bin/mkdir -p ${graphite::params::install_path}/${graphite::params::graphite_dirname}/webapp",
    unless  => "/usr/bin/test -d ${graphite::params::install_path}/${graphite::params::graphite_dirname}/webapp",
    before  => Class['roles::apache2_server']
  }

  exec {'graphite_log_root':
    command => "/bin/mkdir -p ${graphite::params::install_path}/${graphite::params::graphite_dirname}/storage/log/webapp",
    unless  => "/usr/bin/test -d ${graphite::params::install_path}/${graphite::params::graphite_dirname}/storage/log/webapp",
    before  => Class['roles::apache2_server']
  }

  include roles::apache2_server

  apache2::module { 'wsgi':
    package => 'libapache2-mod-wsgi',
    before  => Anchor['role::graphite_server::begin'],
    require => Class['roles::apache2_server']
  }

  apache2::site{'graphite.vhost.conf':
    source              => 'graphite/web/apache2/graphite.vhost.conf.erb',
    include_from_source => 'graphite::params',
    require             => Class['roles::apache2_server']
  }

  apache2::alias{'graphite_alias':
    content => 'Alias /graphite /srv/graphite/webapp',
    before  => Anchor['role::graphite_server::begin']
  }

  htpasswd::user {$htpasswd_user:
    file     => $htpasswd_file,
    password => $htpasswd_pass,
    before   => Anchor['role::graphite_server::begin'],
    require  => Apache2::Module['wsgi']
  }

  anchor { 'role::graphite_server::begin':
    before => Class['graphite::whisper']
  }

  class {'graphite::whisper':
    require => Anchor['role::graphite_server::begin']
  }

  class {'graphite::carbon':
    amqp_enabled  => true,
    amqp_host     => $amqp_host,
    amqp_port     => $amqp_port,
    amqp_user     => $amqp_user,
    amqp_password => $amqp_password,
    amqp_vhost    => '/',
    amqp_exchange => 'graphite',
    require       => Class['graphite::whisper']
  }

  class {'graphite::web':
    require => Class['graphite::carbon']
  }

  graphite::carbon::retentions { 'pruebas_retention':
    pattern    => '^stats.*',
    retentions => '10s:1d,1min:7d,10min:5y',
    require    => Class['graphite::whisper'],
  }

  anchor { 'role::graphite_server::end':
    require => Class['graphite::web']
  }
}

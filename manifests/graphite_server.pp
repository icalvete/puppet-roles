class roles::graphite_server {

  apache2::module { 'wsgi':
    package => 'libapache2-mod-wsgi',
    before  => Anchor['role::graphite_server::begin']
  }

  $htpasswd_file = hiera('htpasswd_file')
  $htpasswd_user = 'graphite'
  $htpasswd_pass = 'gr4ph1t3.-'
  
  htpasswd::user {$htpasswd_user:
    file     => $htpasswd_file,
    password => $htpasswd_pass,
    before   => Anchor['role::graphite_server::begin']
	}

  apache2::site{'graphite.vhost':
    source              => 'graphite/web/apache2/graphite.vhost.erb',
    include_from_source => 'graphite::params',
    before              => Anchor['role::graphite_server::begin']
  }
  
  apache2::alias{'graphite_alias':
    content => 'Alias /graphite /srv/graphite/webapp',
    before	=> Anchor['role::graphite_server::begin']
  }

  anchor { 'role::graphite_server::begin':
    before => Class['graphite::whisper']
  }

  class {'graphite::whisper':
    require => Anchor['role::graphite_server::begin']
  }
  
  class {'graphite::carbon':
    amqp_enabled  => true,
    amqp_host     => hiera('graphite_amqp_server'),
    amqp_port     => hiera('graphite_amqp_port'),
    amqp_user     => hiera('graphite_amqp_user'),
    amqp_password => hiera('graphite_amqp_pass'),
    amqp_vhost    => "/",
    amqp_exchange => "graphite",
    require       => Class['graphite::whisper']
  }

  class {'graphite::web':
    require => Class['graphite::carbon']
  }

  graphite::carbon::retentions { 'pruebas_retention':
    pattern    => "^stats.*",
    retentions => "10s:1d,1min:7d,10min:5y",
    require    => Class['graphite::whisper'],
  }
  
  anchor { 'role::graphite_server::end':
    require => Class['graphite::web']
  }
}

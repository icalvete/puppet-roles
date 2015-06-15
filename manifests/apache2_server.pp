class roles::apache2_server (

  $ssl                    = true,
  $passenger              = true,
  $phalcon                = false,
  $file_uploads           = undef,
  $file_uploads_size      = undef,
  $max_execution_time_cli = undef,
  $max_execution_time_fpm = undef,
  $memory_limit_cli       = undef,
  $memory_limit_fpm       = undef,
  $wsgi                   = undef

) inherits roles {

  include apache2

  class {'php5':
    fpm                    => true,
    phalcon                => $phalcon,
    file_uploads           => $file_uploads,
    file_uploads_size      => $file_uploads_size,
    max_execution_time_cli => $max_execution_time_cli,
    max_execution_time_fpm => $max_execution_time_fpm,
    memory_limit_cli       => $memory_limit_cli,
    memory_limit_fpm       => $memory_limit_fpm,
  }

  if $ssl {

    apache2::module {'ssl':
      require => Class['apache2::install']
    }

    apache2::site {'default-ssl':
      require => Class['apache2::install']
    }
  }

  if $passenger {
    package {'libapache2-mod-passenger':
      ensure => present,
    }

    apache2::module {'passenger':
      require => Class['apache2::install']
    }

  }

  if $wsgi {
    apache2::module {'wsgi':
      package => 'libapache2-mod-wsgi',
      require => Class['apache2::install']
    }

  }

  if defined('check_mk::agent') {
    check_mk::agent::plugin{'apache_status':
      require => Class['check_mk::agent::install']
    }
  }
}

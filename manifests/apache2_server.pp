class roles::apache2_server (

  $file_uploads           = undef,
  $file_uploads_size      = undef,
  $max_execution_time_cli = undef,
  $max_execution_time_fpm = undef,
  $memory_limit_cli       = undef,
  $memory_limit_fpm       = undef,
  $php                    = true,
  $hhvm                   = false,
  $ssl                    = true,
  $wsgi                   = undef,
  $passenger              = true,
  $phalcon                = false,

) inherits roles {
  
  validate_bool($php)
  validate_bool($hhvm)
  validate_bool($ssl)
  validate_bool($passenger)
  validate_bool($phalcon)

  if $php and $hhvm {
      fail('php and hhvm can be true at same time.')
  }

  class{'apache2':
    php  => $php,
    hhvm => $hhvm
  }

  if $php {
    class {'php5':
      fpm                    => true,
      phalcon                => $phalcon,
      opcache                => $opcache,
      opcache_blacklist      => $opcache_blacklist,
      file_uploads           => $file_uploads,
      file_uploads_size      => $file_uploads_size,
      max_execution_time_cli => $max_execution_time_cli,
      max_execution_time_fpm => $max_execution_time_fpm,
      memory_limit_cli       => $memory_limit_cli,
      memory_limit_fpm       => $memory_limit_fpm,
    }
  
    if $wsgi {
      apache2::module {'wsgi':
        package => 'libapache2-mod-wsgi',
        require => Class['apache2::install']
      }
    }
  }

  if $hhvm {
    apache2::module {'proxy_fcgi':
      require => [Class['apache2::install'], Class['hhvm']]
    }

    include hhvm
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

  if defined('check_mk::agent') {
    check_mk::agent::plugin{'apache_status':
      require => Class['check_mk::agent::install']
    }
  }
}

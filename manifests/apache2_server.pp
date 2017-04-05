class roles::apache2_server (

  $ssl                    = true,
  $wsgi                   = undef,
  $passenger              = true,
  $php                    = true,
  $phalcon                = false,
  $hhvm                   = false,
  $opcache                = false,
  $opcache_blacklist      = undef,
  $file_uploads           = undef,
  $file_uploads_size      = undef,
  $max_execution_time_cli = undef,
  $max_execution_time_fpm = undef,
  $memory_limit_cli       = undef,
  $memory_limit_fpm       = undef,
  $server_error_message   = false

) inherits roles {

  $allowed_pph_values_msg = 'Allowed values for php are: true ( 5 by default ) | 5 (default) | 7 '

  if (!is_bool($php)) and (!is_integer($php)) and (!is_string($php))  {
    fail($allowed_pph_values_msg)
  }

  if is_string($php) {
    validate_re($php, ['^5$', '^7$'], $allowed_pph_values_msg)
  }


  validate_bool($ssl)
  validate_bool($passenger)
  validate_bool($hhvm)

  if $php and $hhvm {
      fail('php and hhvm can be true at same time.')
  }

  class{'apache2':
    php  => $php,
    hhvm => $hhvm
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
    apache2::module {'passenger':
      package =>  'libapache2-mod-passenger',
      require => Class['apache2::install']
    }
  }

  if defined('check_mk::agent') {
    check_mk::agent::plugin{'apache_status':
      require => Class['check_mk::agent::install']
    }
  }

  if $php {

    case $php {
      5:{ $php_version = 5 }
      7: {
        if $phalcon {
          fail('phalcon isn\'t available in php 7.')
        }
        $php_version = 7
      }
      default: { $php_version = 5 }
    }

    class {"php${$php_version}":
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
  }

  if $wsgi {
    apache2::module {'wsgi':
      package => 'libapache2-mod-wsgi',
      require => Class['apache2::install']
    }
  }

  if $hhvm {
    apache2::module {'proxy_fcgi':
      require => [Class['apache2::install'], Class['hhvm']]
    }

    class{'hhvm':
      server_error_message => $server_error_message
    }
  }
}

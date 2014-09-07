class roles::apache2_server (

  $ssl               = true,
  $passenger         = true,
  $phalcon           = false,
  $file_uploads      = undef,
  $file_uploads_size = undef

) inherits roles {

  include apache2

  class {'php5':
    fpm               => true,
    phalcon           => $phalcon,
    file_uploads      => $file_uploads,
    file_uploads_size => $file_uploads_size
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

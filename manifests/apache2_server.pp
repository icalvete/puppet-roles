class roles::apache2_server (

  $ssl       = true,
  $passenger = true,

) inherits roles {

  include apache2

  class {'php5':
    fpm => true
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
}

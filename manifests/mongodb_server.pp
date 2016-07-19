class roles::mongodb_server (

  $version             = '3.2.7',
  $bind_ip             = '0.0.0.0',
  $manage_package_repo = true,
  $verbose             = false,
  $backup              = true,
  $backup_dir          = '/srv',
  $backup_retention    = 7,
  $replset             = undef,
  $nojournal           = undef,
  $smallfiles          = undef,
  $pidfilepath         = '/var/run/mongodb.pid',
  $set_parameter       = undef

) inherits roles {

  validate_ip_address($bind_ip)
  validate_bool($manage_package_repo)
  validate_bool($verbose)
  validate_bool($backup)

  apt::key { 'mongodb-org-tools_key':
    id     => 'D68FA50FEA312927',
    server => 'keyserver.ubuntu.com',
    before => Package['mongodb-org-tools']
  }

  class {'::mongodb::globals':
    version             => '3.2.7',
    manage_package_repo => true,
    bind_ip             => '0.0.0.0',
    pidfilepath         => $pidfilepath,
    }->
    class {'::mongodb::client': }->
    class {'::mongodb::server':
      verbose       => true,
      replset       => $replset,
      nojournal     => $nojournal,
      smallfiles    => $smallfiles,
      set_parameter => $set_parameter,
      require       => Class['mongodb::globals']
    }

  package { 'mongodb-org-tools':
    ensure  => present,
    require => Class['mongodb::server']
  }

  if $backup {
    class {roles::mongodb_server::backup:
      backup_dir       => $backup_dir,
      backup_retention => $backup_retention
    }
  }
}

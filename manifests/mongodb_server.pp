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
  $smallfiles          = undef

) inherits roles {

  validate_ip_address($bind_ip)
  validate_bool($manage_package_repo)
  validate_bool($verbose)
  validate_bool($backup)

  class {'::mongodb::globals':
    version             => $version,
    manage_package_repo => $manage_package_repo,
    bind_ip             => $bind_ip
  }->
  class {'::mongodb::client': }->
  class {'::mongodb':
    verbose    => $verbose,
    replset    => $replset,
    nojournal  => $nojournal,
    smallfiles => $smallfiles,
    require    => Class['mongodb::globals']
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

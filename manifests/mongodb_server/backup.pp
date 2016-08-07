class roles::mongodb_server::backup (

  $backup_dir       = '/srv/',
  $backup_retention = 7

){

  file{ 'mongo_backup_dir':
    ensure => directory,
    path   => "${backup_dir}/mongodb",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file {'mongo_backup_script':
    ensure  => present,
    path    => '/root/mongo_backup.sh',
    content => template("${module_name}/mongodb_server/mongo_backup.sh.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
  }

  cron { "add_backup_mongo_${::hostname}":
    command => '/root/mongo_backup.sh',
    user    => 'root',
    hour    => '*/6',
    minute  => '0',
    require => File['mongo_backup_script']
  }
}


class roles::mongodb_server (

  $version             = '3.6.14',
  $bind_ip             = ['0.0.0.0'],
  $manage_package_repo = true,
  $verbose             = false,
  $auth                = undef,
  $keyfile             = undef,
  $key                 = undef,
  $backup              = true,
  $backup_dir          = '/srv',
  $backup_retention    = 7,
  $replset             = undef,
  $nojournal           = undef,
  $smallfiles          = undef,
  $pidfilepath         = '/var/run/mongodb.pid',
  $set_parameter       = undef,
  $nohttpinterface     = false,
  $rest                = false,
  $service_provider    = undef,
  $quiet               = false

) inherits roles {

  include ::rclocal

  ::rclocal::register{ 'tuned_transparent_hugepage':
    content => "
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
  echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi

if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
  echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
",
  }

  class {'::mongodb::globals':
    version             => $version,
    manage_package_repo => true,
    bind_ip             => ['0.0.0.0'],
    pidfilepath         => $pidfilepath,
    }->
    class {'::mongodb::client': }->
    class {'::mongodb::server':
      verbose          => $verbose,
      auth             => $auth,
      keyfile          => $keyfile,
      key              => $key,
      replset          => $replset,
      nojournal        => $nojournal,
      smallfiles       => $smallfiles,
      set_parameter    => $set_parameter,
      nohttpinterface  => $nohttpinterface,
      rest             => $rest,
      service_provider => $service_provider,
      quiet            => $quiet,
      require          => Class['mongodb::globals']
    }

    package { 'mongodb-org-tools':
      ensure  => present,
      require => [
        Apt::Source['mongodb'],
        Class['Apt::Update']
      ]
    }

  if $backup {
    class {roles::mongodb_server::backup:
      backup_dir       => $backup_dir,
      backup_retention => $backup_retention
    }
  }

  logrotate::rule { 'mongod':
    path          => '/var/log/mongodb/mongodb.log',
    rotate        => '7',
    rotate_every  => 'daily',
    missingok     => true,
    ifempty       => false,
    compress      => true,
    delaycompress => true,
    postrotate    => '/bin/kill -SIGUSR1 `/bin/cat /var/run/mongodb.pid` > /dev/null 2>&1 || true',
    su            => true,
    su_owner      => 'mongodb',
    su_group      => 'mongodb'
  }

  # if auth ...

  # Create root user.
  #
  # use admin
  #
  # db.createUser(
  #   {
  #     user: "root",
  #     pwd: "password",
  #     roles: [ "root" ]
  #   }
  # )
  #
  # rep:PRIMARY> use admin
  # switched to db admin
  # rep:PRIMARY> db.createUser({user: "root", pwd: "*******", roles: ["root"]})
  # Successfully added user: { "user" : "root", "roles" : [ "root" ] }
}

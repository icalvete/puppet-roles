class roles::syslog_remote_server (

  $root_log_dir = hiera('root_log_dir'),
  $log_dir      = hiera('sp_log_dir'),
  $log          = hiera('sp_log'),
  $glacier      = false,
  $glacier_vault = undef

) inherits roles {

  if $glacier == true and ! $glacier_vault {
        fail('To save logs in glacier, a vault is required.')
  }

  if $glacier == true {
    file { 'glacier_install_config':
      ensure  => 'present',
      path    => "/root/bin/glacier.sh",
      content => template("${module_name}/syslog_remote_server/glacier.sh.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0775'
    }
  }

  syslogng::load_conf{'syslog_receiver':
    conf    => { source => '00receiver.conf.erb', target => '00receiver.conf' },
    log_dir => $log_dir,
    log     => $log
  }

  logrotate::rule { 'org_logs_local3':
    path          => "${root_log_dir}/${log_dir}/local3*.log",
    rotate        => 7,
    rotate_every  => 'day',
    compress      => true,
    missingok     => true,
    ifempty       => true,
  }

  logrotate::rule { 'org_logs_local4':
    path          => "${root_log_dir}/${log_dir}/local4*.log",
    rotate        => 7,
    rotate_every  => 'day',
    compress      => true,
    missingok     => true,
    ifempty       => true,
  }

  logrotate::rule { 'org_logs_local5':
    path          => "${root_log_dir}/${log_dir}/local5*.log",
    rotate        => 6,
    rotate_every  => 'month',
    compress      => true,
    missingok     => true,
    ifempty       => true,
  }

  logrotate::rule { 'php5-fpm':
    path          => "${root_log_dir}/php5-fpm.log",
    rotate        => 12,
    rotate_every  => 'weekly',
    missingok     => true,
    ifempty       => false,
    compress      => true,
    delaycompress => true,
    postrotate    => '/usr/lib/php5/php5-fpm-reopenlogs',
    su            => true,
    su_owner      => 'root',
    su_group      => 'root'
  }
}

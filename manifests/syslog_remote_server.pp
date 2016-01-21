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
    file { 'graphite_install_config':
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

  logrotate::rule { 'org_logs':
    path          => "${root_log_dir}/${log_dir}/*.log",
    rotate        => 7,
    rotate_every  => 'day',
    compress      => true,
    missingok     => true,
    ifempty       => true,
    sharedscripts => true,
    postrotate    => "/root/bin/glacier.sh ${glacier} > /dev/null"
  }

  logrotate::rule { 'apport':
    path          => "${root_log_dir}/apport.log",
    rotate        => 7,
    rotate_every  => 'day',
    delaycompress => true,
    compress      => true,
    ifempty       => false,
    missingok     => true,
    su            => true,
    su_owner      => 'root',
    su_group      => 'root'
  }

  logrotate::rule { 'aptitude':
    path         => "${root_log_dir}/aptitude",
    rotate       => 6,
    rotate_every => 'monthly',
    compress     => true,
    ifempty      => false,
    missingok    => true,
    su           => true,
    su_owner     => 'root',
    su_group     => 'root'
  }

  logrotate::rule { 'btmp':
    path         => "${root_log_dir}/btmp",
    compress     => true,
    create       => true,
    create_mode  => '0644',
    create_owner => 'root',
    create_group => 'utmp',
    ifempty      => true,
    missingok    => true,
    rotate_every => 'monthly',
    rotate       => 1,
    su           => true,
    su_owner     => 'root',
    su_group     => 'utmp'
  }

  logrotate::rule { 'wtmp':
    path         => "${root_log_dir}/wtmp",
    compress     => true,
    create       => true,
    create_mode  => '0644',
    create_owner => 'root',
    create_group => 'utmp',
    ifempty      => true,
    missingok    => true,
    rotate_every => 'monthly',
    rotate       => 1,
    su           => true,
    su_owner     => 'root',
    su_group     => 'utmp'
  }

  logrotate::rule { 'dpkg':
    path          => "${root_log_dir}/dpkg.log",
    rotate_every  => 'monthly',
    rotate        => 12,
    compress      => true,
    delaycompress => true,
    missingok     => true,
    ifempty       => false,
    create        => true,
    create_mode   => '0644',
    create_owner  => 'root',
    create_group  => 'root',
    su            => true,
    su_owner      => 'root',
    su_group      => 'root'
  }

  logrotate::rule { 'alternatives':
    path          => "${root_log_dir}/alternatives.log",
    rotate_every  => 'monthly',
    rotate        => 12,
    compress      => true,
    delaycompress => true,
    missingok     => true,
    ifempty       => false,
    create        => true,
    create_mode   => '0644',
    create_owner  => 'root',
    create_group  => 'root',
    su            => true,
    su_owner      => 'root',
    su_group      => 'root'
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

  logrotate::rule { 'ppp':
    path         => "${root_log_dir}/ppp-connect-errors",
    rotate_every => 'weekly',
    rotate       => 4,
    missingok    => true,
    ifempty      => false,
    compress     => true,
    create       => false,
    su           => true,
    su_owner     => 'root',
    su_group     => 'root'
  }

  logrotate::rule { 'ufw':
    path          => "${root_log_dir}/ufw.log",
    rotate        => 4,
    rotate_every  => 'weekly',
    missingok     => true,
    ifempty       => false,
    compress      => true,
    delaycompress => true,
    sharedscripts => true,
    postrotate    => 'invoke-rc.d rsyslog reload > /dev/null 2>&1 || true',
    su            => true,
    su_owner      => 'root',
    su_group      => 'root'
  }
}

class roles::syslog_remote_server (

  $root_log_dir = hiera('root_log_dir'),
  $log_dir      = hiera('sp_log_dir'),
  $log          = hiera('sp_log')

) inherits roles {

  syslogng::load_conf{'syslog_receiver':
    conf    => { source => '00receiver.conf.erb', target => '00receiver.conf' },
    log_dir => $log_dir,
    log     => $log
  }

  logrotate::rule { 'org_logs':
    path         => "${root_log_dir}/${log_dir}/*.log",
    rotate       => 7,
    rotate_every => 'day',
    compress     => true,
    missingok    => true,
    ifempty      => true
  }
}

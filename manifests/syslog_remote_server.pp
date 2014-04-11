class roles::syslog_remote_server (

  $log_dir      = hiera('sp_log_dir'),
  $log          = hiera('sp_log')

) inherits roles {

  syslogng::load_conf{'syslog_receiver':
    conf    => { source => '00receiver.conf.erb', target => '00receiver.conf' },
    log_dir => $log_dir,
    log     => $log
  }
}

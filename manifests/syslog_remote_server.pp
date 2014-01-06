class roles::syslog_remote_server inherits roles {

  syslogng::load_conf{'syslog_receiver':
    conf    => { source => '00receiver.conf.erb', target => '00receiver.conf' },
    log_dir => hiera('syslog_log_dir'),
    log     => hiera('syslog_log'),
  }
}

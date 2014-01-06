class roles::syslog_sender_server inherits roles {

  syslogng::load_conf{'syslog_sender':
    conf                 => { source => '00sender.conf.erb', target => '00sender.conf' },
    syslog_remote_server => hiera('syslog_remote_server')
  }
}

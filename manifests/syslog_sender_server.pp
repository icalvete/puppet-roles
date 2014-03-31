class roles::syslog_sender_server (

$syslog_remote_server = undef,
$syslog_remote_port   = undef

) inherits roles {

  syslogng::load_conf{'syslog_sender':
    conf                 => { source => '00sender.conf.erb', target => '00sender.conf' },
    syslog_remote_server => $syslog_remote_server,
    syslog_remote_port   => $syslog_remote_port
  }
}

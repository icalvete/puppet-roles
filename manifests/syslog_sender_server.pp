class roles::syslog_sender_server (

$syslog_remote_server   = undef,
$syslog_remote_port     = 514,
$logstash_remote_server = undef,
$logstash_remote_port   = undef,
$logstash_protocol      = 'udp'

) inherits roles {

  syslogng::load_conf{'syslog_sender':
    conf                   => {
      source => '00sender.conf.erb',
      target => '00sender.conf'
    },
    syslog_remote_server   => $syslog_remote_server,
    syslog_remote_port     => $syslog_remote_port,
    logstash_remote_server => $logstash_remote_server,
    logstash_remote_port   => $logstash_remote_port
  }
}

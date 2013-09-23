class roles::syslog_remote_server inherits roles {
	
  syslogng::load_conf{'syslog_receiver':
	  conf    => { source => '00receiver.conf.erb', target => '00sp_receiver.conf' },
	  log_dir => hiera('sp_log_dir'),
    log     => hiera('sp_log'),
	}
}

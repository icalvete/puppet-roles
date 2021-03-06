class roles::td_agent_server (

  $elasticsearch_host  = undef,
  $elasticsearch_port  = 9200,
  $fluentd_remote_port = 5514,
  $main_config         = 'fluentd/sp.conf.erb',
  $protocol_type       = 'udp',
  $config_template     = ['fluentd/sp_l4.conf', 'fluentd/sp_l5.conf'],

) inherits roles {

  include fluentd

  class {'fluentd::td_agent':
    elasticsearch_host => $elasticsearch_host,
    elasticsearch_port => $elasticsearch_port,
    remote_port        => $fluentd_remote_port,
    main_config        => $main_config,
    protocol_type      => $protocol_type
  }

  if $config_template {
    fluentd::td_agent::add_config{$config_template:}
  }
}

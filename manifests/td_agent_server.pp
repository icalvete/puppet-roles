class roles::td_agent_server (

  $config_template     = undef,
  $elasticsearch_host  = undef,
  $elasticsearch_port  = 9200,
  $fluentd_remote_port = 5514,
  $main_config         = 'fluentd/sp.conf.erb',
  $config_template     = undef,

) inherits roles {

  include fluentd

  class {'fluentd::td_agent':
    elasticsearch_host => $elasticsearch_host,
    elasticsearch_port => $elasticsearch_port,
    remote_port        => $fluentd_remote_port,
    main_config        => $main_config
  }

  if $config_template {
    fluentd::td_agent::add_config{$config_template:}
  }
}

class roles::td_agent_server (

  $config_template    = undef,
  $elasticsearch_host = undef

) inherits roles {

  include fluentd

  class {'fluentd::td-agent':
    elasticsearch_host => $elasticsearch_host
  }

  if $config_template {
    fluentd::td-agent::add_config{$config_template:}
  }
}

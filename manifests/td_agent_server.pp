class roles::td_agent_server (

  $config_template    = undef,
  $elasticsearch_host = undef

) inherits roles {

  include fluentd
  class {'fluentd::td-agent':
    config_template    => $config_template,
    elasticsearch_host => $elasticsearch_host
  }
}

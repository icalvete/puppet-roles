class roles::td_agent_server (

  $elasticsearch_host = undef

) inherits roles {

  include fluentd
  class {'fluentd::td-agent':
    elasticsearch_host => $elasticsearch_host
  }
}

class roles::td_agent_server (

  $elasticsearch_host = undef,
  $elasticsearch_port = 9200,
  $main_config        = undef,
  $config_template    = undef,

) inherits roles {

  include fluentd

  class {'fluentd::td_agent':
    elasticsearch_host => $elasticsearch_host,
    main_config        => $main_config
  }

  if $config_template {
    fluentd::td_agent::add_config{$config_template:}
  }
}

class roles::td_agent_server (

  $config_template    = undef,
  $elasticsearch_host = undef,
  $main_config        = undef,

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

class roles::td_agent_server inherits roles { 

  include fluentd
  include fluentd::td-agent
}

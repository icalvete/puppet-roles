class roles::puppet_agent (

  $puppet_config            = undef,
  $puppet_server            = undef,
  $puppet_certname          = undef,
  $puppet_dashboard_db_host = undef,
  $puppet_env               = undef,

) {

  class {'puppet::agent':
    puppet_config            => $puppet_config,
    puppet_server            => $puppet_server,
    puppet_certname          => $puppet_certname,
    puppet_dashboard_db_host => $puppet_dashboard_db_host,
    puppet_env               => $puppet_env,
  }
}

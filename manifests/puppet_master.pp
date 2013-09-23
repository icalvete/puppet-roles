class roles::puppet_master (

  $puppet_server            = undef,
  $puppet_certname          = undef,
  $puppet_db                = undef,
  $puppet_dashboard_db_host = undef,
  $puppet_modulepath        = undef,
  $puppet_env               = undef,

) {

  class {'puppet::master':
    puppet_server            => $puppet_server,
    puppet_certname          => $puppet_certname,
    puppet_db                => $puppet_db,
    puppet_dashboard_db_host => $puppet_dashboard_db_host,
    puppet_modulepath        => $puppet_modulepath,
    puppet_env               => $puppet_env,
  }
}

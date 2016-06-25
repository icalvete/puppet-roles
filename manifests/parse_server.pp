class roles::parse_server (

  $application_id = undef,
  $master_key     = undef,

) inherits roles {

  if $application_id == undef {
    fail('application_id must be a string')
  }

  if $master_key == undef {
    fail('master_key must be a string')
  }

  include nodejs

  class {'parse_platform::server':
    application_id => $application_id,
    master_key     => $master_key,
    require        => Class['nodejs']
  }
}

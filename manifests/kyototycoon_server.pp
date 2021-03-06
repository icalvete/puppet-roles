class roles::kyototycoon_server (

  $hamaster  = undef,
  $threads   = undef,
  $log_level = undef,
  $memcached = true,
  $mhost     = undef,
  $sid       = undef,
  $db_type   = undef,
  $plex_port = undef,
  $backup    = false

) inherits roles {

  class {'kyototycoon':
    hamaster  => $hamaster,
    memcached => $memcached,
    mhost     => $mhost,
    sid       => $sid,
    db_type   => $db_type,
    plex_port => $plex_port,
    backup    => $backup
  }
}

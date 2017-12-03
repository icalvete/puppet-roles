class roles::kyototycoon_server (

  $hamaster  = undef,
  $threads   = undef,
  $log_level = undef,
  $memcached = true,
  $mhost     = undef,
  $sid       = undef,

) inherits roles {

  class {'kyototycoon':
    hamaster  => $hamaster,
    memcached => $memcached,
    mhost     => $mhost,
    sid       => $sid
  }
}

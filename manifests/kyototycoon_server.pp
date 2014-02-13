class roles::kyototycoon_server (

  $memcached = true,

) inherits roles {

  class {'kyototycoon':
    memcached => $memcached
  }
}

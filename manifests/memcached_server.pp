class roles::memcached_server (

  $port            = undef,
  $memory          = undef,
  $max_object_size = undef

) inherits roles {

    class {'memcached':
      port            => $port,
      memory          => $memory,
      max_object_size => $max_object_size
    }
}

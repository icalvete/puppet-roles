class roles::memcached_server (

  $memory          = undef,
  $max_object_size = undef

) inherits roles {

    class {'memcached':
      memory          => $memory,
      max_object_size => $max_object_size
    }
}

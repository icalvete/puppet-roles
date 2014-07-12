class roles::mongodb_server (

  $backup = undef

) inherits roles {

  class {'mongodb':
    backup => $backup
  }
}

class roles::mongodb_server (

  $backup   = undef,
  $official = true

) inherits roles {

  class {'mongodb':
    backup  => $backup,
    official => $official
  }
}

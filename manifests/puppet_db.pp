class roles::puppet_db (

  $puppet_server = undef,

) {

  class {'puppet::db':
    puppet_server => $puppet_server,
  }
}

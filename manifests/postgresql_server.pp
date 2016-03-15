class roles::postgresql_server (

  $s3_backup = false

) inherits roles {

  class { 'postgresql::server': }
}

class roles::mysql_server (

  $s3_backup = false

) inherits roles {

  class {'mysql::server':
    s3_backup => $3_backup,
  }
}

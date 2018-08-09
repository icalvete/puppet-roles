class roles::mysql_server (

  $version    = "5"
  $root_user  = undef,
  $root_pass  = undef,
  $backup_dir = undef,
  $s3_backup  = false,
  $id         = undef

) inherits roles {

  class {'mysql::client':
    version =>  $version
  }

  class {'mysql::server':
    version    => $version
    root_user  => $root_user,
    root_pass  => $root_pass,
    backup_dir => $backup_dir,
    s3_backup  => $3_backup,
    id         => $id
  }
}

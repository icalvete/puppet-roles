class roles::mysql_server (

  $root_user  = undef,
  $root_pass  = undef,
  $backup_dir = undef,
  $s3_backup  = false,
  $id         = undef

) inherits roles {

  include mysql::client

  class {'mysql::server':
    root_user  => $root_user,
    root_pass  => $root_pass,
    backup_dir => $backup_dir,
    s3_backup  => $3_backup,
    id         => $id
  }
}

class roles::glusterfs_server (

  $volume_name       = undef,
  $volume_data       = undef,
  $volume_mountpoint = undef,
  $volume_type       = undef

) inherits roles {

  package {'xfsprogs':
      ensure => present,
      before => Glusterfs::Brick[$volume_name]
  }


  if ! $volume_name {
    fail('A GlusterFS cluster needs a volumen_name.')
  }

  if ! $volume_data and ! is_hash($volume_data) {
    fail('A GlusterFS cluster needs some volumen data.')
  }

  if ! $volume_mountpoint {
    fail('A GlusterFS cluster needs a volume mountpoint.')
  }

  if ! $volume_type {
    fail('A GlusterFS cluster needs a volume type.')
  }

  $peers  = keys($volume_data)
  $size   = size($peers)
  $bricks = glusterFunctions($volume_data, 'formatBricks')

  include glusterfs::server

  glusterfs::brick {$volume_name:
    dev        => $volume_data[$::ipaddress_eth1]['dev'],
    mountpoint => $volume_data[$::ipaddress_eth1]['mountpoint'],
  }

  glusterfs::peer::probe{$peers:
    require => Class['glusterfs::server'],
    before  => Glusterfs::Volume::Create[$volume_name]
  }

  glusterfs::volume::create {$volume_name:
    type              => $volume_type,
    type_count        => $size,
    bricks            => $bricks,
    volume_mountpoint => $volume_mountpoint,
    require           => Glusterfs::Brick[$volume_name]
  }
}

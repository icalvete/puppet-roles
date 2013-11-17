define roles::pacemaker_cluster(

  $cluster_name    = $name,
  $service_name    = $name,
  $drbd_resource   = $name,
  $drbd_device     = '/dev/drbd0',
  $drbd_disk       = '/dev/vdb1',
  $drbd_port       = '7789',
  $drbd_mountpoint = undef,
  $node_active     = undef,
  $ip_active       = undef,
  $node_passive    = undef,
  $ip_passive      = undef,
  $vip             = undef,
  $cidr_netmask    = '24',

) {

  anchor{"roles::pacemaker_cluster::${name}::begin":}

  if $node_active == $::fqdn {
    $ha_primary    = true
    $initial_setup = true
  } else {
    $ha_primary    = false
    $initial_setup = false
  }

  if ! defined(Class['pacemaker']) {
    class { 'pacemaker':
      asymetrical       => false,
      unicast_addresses => [$ip_active, $ip_passive],
      require           => Anchor["roles::pacemaker_cluster::${name}::begin"],
      before            => Anchor["roles::pacemaker_cluster::${name}::end"]
    }
  }

  drbd::resource { $drbd_resource:
    host1         => $node_active,
    host2         => $node_passive,
    ip1           => $ip_active,
    ip2           => $ip_passive,
    disk          => $drbd_disk,
    port          => $drbd_port,
    device        => $drbd_device,
    manage        => true,
    verify_alg    => 'sha1',
    ha_primary    => $ha_primary,
    initial_setup => $initial_setup,
    automount     => false,
    before        => Class['pacemaker']
  }

  pacemaker::cluster {$cluster_name:
    asymetrical     => false,
    service         => $service_name,
    vip             => $vip,
    drbd_resource   => $drbd_resource,
    drbd_device     => $drbd_device,
    drbd_mountpoint => $drbd_mountpoint,
    cidr_netmask    => $cidr_netmask,
    node_active     => $node_active,
    node_passive    => $node_passive,
    require         => [Drbd::Resource[$drbd_resource],Class['pacemaker']]
  }

  anchor{"roles::pacemaker_cluster::${name}::end":}

}

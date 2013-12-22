class roles::ldap_server (
  
  $backup_local   = true,
  $cluster        = false,
  $cluster_peer   = undef,
  $replication_id = undef

) inherits roles {
  
  if $cluster {
    if ! $cluster_peer {
      fail('Cluster node needs a peer. Set cluster_peer param.')
    }
    if ! $replication_id {
      fail('Cluster node needs replication_id param.')
    }
  }

  class {'389ds':
    backup_local   => $backup_local,
    cluster        => $cluster,
    cluster_peer   => $cluster_peer,
    replication_id => $replication_id
  }
}


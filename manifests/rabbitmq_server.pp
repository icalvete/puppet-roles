class roles::rabbitmq_server (

  $admin_user               = 'admin',
  $admin_pass               = 'admin',
  $config_cluster           = false,
  $cluster_node_type        = 'disc',
  $cluster_nodes            = undef,
  $erlang_cookie            = 'A_SECRET_COOKIE_STRING',
  $wipe_db_on_cookie_change = true,


) inherits roles {

  if $config_cluster and !$cluster_nodes {
    fail('cluster_nodes must be an array if config_cluster is true')
  }

  class { '::rabbitmq':
    service_manage           => false,
    port                     => '5672',
    delete_guest_user        => true,
    config_cluster           => $config_cluster,
    cluster_node_type        => $cluster_node_type,
    cluster_nodes            => $cluster_nodes,
    erlang_cookie            => $erlang_cookie,
    wipe_db_on_cookie_change => $wipe_db_on_cookie_change
  }

  rabbitmq_user { $admin_user:
    admin    => true,
    password => $admin_pass,
  }

  rabbitmq_user_permissions { "${admin_user}@/":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_plugin { 'rabbitmq_management':
    ensure   => present,
    require  => Class['rabbitmq::install'],
    notify   => Class['rabbitmq::service'],
    provider => 'rabbitmqplugins',
  }
}

class roles::rabbitmq_server (

  $admin_user = 'admin',
  $admin_pass = 'admin'

) inherits roles {

  class { '::rabbitmq':
    service_manage    => false,
    port              => '5672',
    delete_guest_user => true,
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

class roles::elasticsearch_server (

  $status           = 'enabled',
  $manage_repo      = true,
  $repo_version     = '2.x',
  $version          = false,
  $java_install     = true,
  $cluster_name     = 'clustername',
  $default_template = undef,
  $default_script   = undef,
  $bind_host        = $ipaddress,
  $publish_host     = $ipaddress,
  $hosts            = [$ipaddress]

) inherits roles {

  class { 'elasticsearch':
    status                                   => $status,
    manage_repo                              => $manage_repo,
    repo_version                             => $repo_version,
    version                                  => $version,
    java_install                             => $java_install,
    config                                   => {
      'network.bind_host'                    => $bind_host,
      'network.publish_host'                 => $publish_host,
      'cluster.name'                         => $cluster_name,
      'discovery.zen.ping.unicast.hosts'     => $hosts,
      'discovery.zen.ping.multicast.enabled' => false,
      'index.store.type'                     => 'niofs',
      'index.store.compress.stored'          => true,
      'bootstrap.mlockall'                   => true,
      'http.compression'                     => true,
      'transport.tcp.compress'               => true
    },
  }

  #'node.name'                        => $hostname,
  elasticsearch::instance { $hostname: }

  if  $default_template {
    elasticsearch::template { 'elasticsearch_template':
      ensure => 'present',
      file   => $default_template
    }
  }

  if $default_script {
    elasticsearch::script { 'script_template':
      ensure => 'present',
      source => $default_script
    }
  }
}

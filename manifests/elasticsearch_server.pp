class roles::elasticsearch_server (

  $status               = 'enabled',
  $manage_repo          = true,
  $repo_version         = '2.x',
  $version              = false,
  $cluster_name         = 'clustername',
  $bind_host            = $ipaddress,
  $publish_host         = $ipaddress,
  $hosts                = [$ipaddress],
  $data_path            = "/var/lib/elasticsearch-${hostname}",
  $repo_path            = '/var/lib/elasticsearch',
  $minimum_master_nodes = 1,
  $recover_after_nodes  = 1,
  $expected_nodes       = 1,
  $recover_after_time   = '5m',
  $default_template     = 'puppet:///modules/roles/elasticsearch/logstash_template_no_cluster.json',
  $default_script       = undef,
  $jvm_options          = [],
  $memory4es            = floor($memorysize_mb) / 2

) inherits roles {

  limits::fragment {
    '*/soft/memlock': value => 'unlimited';
    '*/hard/memlock': value => 'unlimited';
  }

  limits::fragment {
    '*/soft/nofile': value => 65536;
    '*/hard/nofile': value => 65536;
  }

  limits::fragment {
    'elasticsearch/soft/memlock': value => 'unlimited';
    'elasticsearch/hard/memlock': value => 'unlimited';
  }

  limits::fragment {
    'elasticsearch/soft/nofile': value => 65536;
    'elasticsearch/hard/nofile': value => 65536;
  }

  $config_default = {
    'network.bind_host'    => $bind_host,
    'network.publish_host' => $publish_host,
    'cluster.name'         => $cluster_name,
  }

  $config_2 = {
    'network.bind_host'                    => $bind_host,
    'network.publish_host'                 => $publish_host,
    'discovery.zen.ping.unicast.hosts'     => $hosts,
    'discovery.zen.ping.multicast.enabled' => false,
    'hostname'                             => $hostname,
    'node.name'                            => $hostname,
    'index.store.type'                     => 'niofs',
    'index.store.compress.stored'          => true,
    'bootstrap.mlockall'                   => true,
    'http.compression'                     => true,
    'transport.tcp.compress'               => true,
    'discovery.zen.minimum_master_nodes'   => $minimum_master_nodes,
    'gateway.recover_after_nodes'          => $recover_after_nodes,
    'gateway.expected_nodes'               => $expected_nodes,
    'gateway.recover_after_time'           => $recover_after_time,
    'path.repo'                            => $repo_path
  }

  $config_5 = {
    'network.bind_host'                  => $bind_host,
    'network.publish_host'               => $publish_host,
    'discovery.zen.ping.unicast.hosts'   => $hosts,
    'node.name'                          => $hostname,
    'index.store.type'                   => 'niofs',
    'http.compression'                   => true,
    'transport.tcp.compress'             => true,
    'discovery.zen.minimum_master_nodes' => $minimum_master_nodes,
    'gateway.recover_after_nodes'        => $recover_after_nodes,
    'gateway.expected_nodes'             => $expected_nodes,
    'gateway.recover_after_time'         => $recover_after_time,
    'path.repo'                          => $repo_path
  }

  case $repo_version {
    '2.x': {
      $config = merge($config_default, $config_2)
    }
    '5.x': {
      $config = merge($config_default, $config_5)
    }
    '6.x': {
      $config = merge($config_default, $config_5)
    }
    default: {
      $config = $config_default
    }
  }

  include ::java

  class { 'elasticsearch':
    status       => $status,
    manage_repo  => $manage_repo,
    version      => $version,
    config       => $config,
    jvm_options  => $jvm_options

  }

  common::add_env { 'ES_HEAP_SIZE':
    key     => 'ES_HEAP_SIZE',
    value   => "${memory4es}M",
  }

  elasticsearch::instance { $hostname:
    datadir => $data_path,
    require => Common::Add_env['ES_HEAP_SIZE']
  }
  if  $default_template {
    elasticsearch::template { 'elasticsearch_template':
      ensure   => 'present',
      api_host => $publish_host,
      source   => $default_template
    }
  }
  if $default_script {
    elasticsearch::script { 'script_template':
      ensure => 'present',
      host   => $publish_host,
      source => $default_script
    }
  }
}

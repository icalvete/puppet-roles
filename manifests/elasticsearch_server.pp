class roles::elasticsearch_server (

  $status               = 'enabled',
  $manage_repo          = true,
  $repo_version         = '2.x',
  $version              = false,
  $java_install         = true,
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
      ensure => 'present',
      host   => $publish_host,
      file   => $default_template
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

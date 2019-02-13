define roles::elasticsearch_server::clean_indexes (

  $elasticsearch_host = 'localhost',
  $regexp = '^logstash-([0-9]{4})\.([0-9]{2})\.([0-9]{2})',
  $max_age = 31

) {

  $path = "/root/${name}_clean_indexes.php"

  file { "${name}_clean_indexes_script":
    ensure  => present,
    path    => $path,
    content => template("${module_name}/elasticsearch_server/clean_indexes.php.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  cron{ "${name}_clean_indexes_cron":
    command => "/usr/bin/php ${path}",
    user    => 'root',
    hour    => 4,
    minute  => 15,
    require => File["${name}_clean_indexes_script"]
  }
}

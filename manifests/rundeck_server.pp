class roles::rundeck_server (

  $version          = '2.6.2-1-GA',
  $ssl_enabled      = true,
  $server_name      = $::fqdn,
  $server_hostname  = $::fqdn,
  $server_port      = 4440,
  $username         = 'admin',
  $password         = 'admin',
  $profile_template = undef

) {


  $server_url = "http://${server_name}:${server_port}"

  $framework_config = {
    'framework.server.name'     => $server_name,
    'framework.server.hostname' => $server_hostname,
    'framework.server.port'     => $server_port,
    'framework.server.url'      => $server_url,
    'framework.server.username' => $username,
    'framework.server.password' => $password,
  }

  $auth_config = {
    'file' => {
      'admin_user'     => $username,
      'admin_password' => $password,
    },
  }

  class {'rundeck':
    package_ensure    => $version,
    ssl_enabled       => $ssl_enabled,
    framework_config  => $framework_config,
    auth_config       => $auth_config,
    grails_server_url => $server_url,
    profile_template  => $profile_template,
  }
}

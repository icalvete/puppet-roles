class roles {

# In order yo avoid this bug.
# https://github.com/rodjek/puppet-logrotate/issues/50

  file { '/etc/logrotate.d/00_global':
    content => "su root syslog\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
  }
}

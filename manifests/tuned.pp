class roles::tuned {

  $nofile = '999999'

  limits::fragment {
    'root/soft/nofile': value => $nofile;
    '*/soft/nofile': value    => $nofile;
    'root/hard/nofile': value => $nofile;
    '*/hard/nofile': value    => $nofile;
  }

  # Increase size of file handles and inode cache
  sysctl::value { 'fs.file-max':
    ensure => 'present',
    value  => $nofile
  }

  # Allowed local port range
  sysctl::value { 'net.ipv4.ip_local_port_range':
    ensure => 'present',
    value  => '1024 65535'
  }

  ### TUNING NETWORK PERFORMANCE ###

  # Do a 'modprobe tcp_cubic' first
  sysctl::value { 'net.ipv4.tcp_congestion_control':
    ensure => 'present',
    value  => 'cubic'
  }
  #Turn on the tcp_window_scaling
  sysctl::value { 'net.ipv4.tcp_window_scaling':
    ensure => 'present',
    value  => 1
  }

  # Increase the maximum total buffer-space allocatable
  # This is measured in units of pages (4096 bytes)
  # This gives the kernel more memory for tcp
  # which you need with many (100k+) open socket connections

  $buffer_space = "65536 131072 262144"

  sysctl::value { 'net.ipv4.tcp_mem':
    ensure => 'present',
    value  => $buffer_space
  }
  sysctl::value { 'net.ipv4.udp_mem':
    ensure => 'present',
    value  => $buffer_space
  }
  # I was also masquerading the port comet was on, you might not need this
  # net.ipv4.netfilter.ip_conntrack_max = 1048576

  # Increase the read-buffer space allocatable
  sysctl::value { 'net.ipv4.tcp_rmem':
    ensure => 'present',
    value  => "8192 87380 16777216"
  }
  sysctl::value { 'net.ipv4.udp_rmem_min':
    ensure => 'present',
    value  => 16384
  }
  sysctl::value { 'net.core.rmem_default':
    ensure => 'present',
    value  => 87380
  }
  sysctl::value { 'net.core.rmem_max':
    ensure => 'present',
    value  => 16777216
  }

  # Increase the write-buffer-space allocatable
  sysctl::value { 'net.ipv4.tcp_wmem':
    ensure => 'present',
    value  => "8192 65536 16777216"
  }
  sysctl::value { 'net.ipv4.udp_wmem_min':
    ensure => 'present',
    value  => 16384
  }
  sysctl::value { 'net.core.wmem_default':
    ensure => 'present',
    value  => 65536
  }
  sysctl::value { 'net.core.wmem_max':
    ensure => 'present',
    value  => 16777216
  }

  # General gigabit tuning:
  #net.core.rmem_max = 16777216
  #net.core.wmem_max = 16777216
  #net.ipv4.tcp_rmem = 4096 87380 16777216
  #net.ipv4.tcp_wmem = 4096 65536 16777216

  # possible SYN flooding on port 8080. Sending cookies.
  sysctl::value { 'net.ipv4.tcp_syncookies':
    ensure => 'present',
    value  => 0
  }

  #
  sysctl::value { 'net.ipv4.tcp_max_tw_buckets':
    ensure => 'present',
    value  => 360000
  }
  sysctl::value { 'net.core.netdev_max_backlog':
    ensure => 'present',
    value  => 2500
  }
  sysctl::value { 'vm.min_free_kbytes':
    ensure => 'present',
    value  => 65536
  }
  sysctl::value { 'vm.swappiness':
    ensure => 'present',
    value  => 10
  }

  sysctl::value { 'net.ipv4.tcp_tw_recycle':
    ensure => 'present',
    value  => 0
  }
  sysctl::value { 'net.ipv4.tcp_tw_reuse':
    ensure => 'present',
    value  => 0
  }
  sysctl::value { 'net.ipv4.tcp_orphan_retries':
    ensure => 'present',
    value  => 1
  }
  sysctl::value { 'net.ipv4.tcp_fin_timeout':
    ensure => 'present',
    value  => 25
  }
  # raise this high
  sysctl::value { 'net.ipv4.tcp_max_orphans':
    ensure => 'present',
    value  => 819200
  }

  # http://simonhf.wordpress.com/2010/10/01/node-js-versus-sxe-hello-world-complexity-speed-and-memory-usage/
  sysctl::value { 'net.core.somaxconn':
    ensure => 'present',
    value  => 65535
  }

  sysctl::value { 'net.ipv4.tcp_no_metrics_save':
    ensure => 'present',
    value  => 1
  }
  sysctl::value { 'net.ipv4.tcp_max_syn_backlog':
    ensure => 'present',
    value  => 20480
  }
}

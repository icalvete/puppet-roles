#puppet-roles

 [![Build Status](https://secure.travis-ci.org/icalvete/puppet-roles.png)](http://travis-ci.org/icalvete/puppet-roles)

#Actions

* Roles usefull for https://github.com/icalvete?tab=repositories

##Requires:

* [hiera](http://docs.puppetlabs.com/hiera/1/index.html)

##Example:

```puppet
node 'zoth-ommog.smartpurposes.net' inherits sp_defaults {
  include roles::puppet_master
  include roles::puppet_db
  include roles::puppet_dashboard
  include roles::syslog_sender_server
  include roles::mysql_server
}
```

##Authors:
 
 Israel Calvete Talavera <icalvete@gmail.com>

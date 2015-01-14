# == Class: beaver::service
#
# This class exists to coordinate all service management related actions,
# functionality and logical units in a central place.
#
# <b>Note:</b> "service" is the Puppet term and type for background processes
# in general and is used in a platform-independent way. E.g. "service" means
# "daemon" in relation to Unix-like systems.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'beaver::service': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class beaver::service {

  file { '/etc/init.d/beaver':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/etc/init.d/beaver.${::osfamily}"
  }

  service { 'beaver':
    ensure     => $beaver::service_ensure,
    enable     => $beaver::service_enable,
    name       => $beaver::service_name,
    hasstatus  => $beaver::service_hasstatus,
    hasrestart => $beaver::service_hasrestart,
    pattern    => $beaver::service_pattern,
    require    => File['/etc/init.d/beaver']
  }

}

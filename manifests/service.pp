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

  if $beaver::service_provider == 'init' {

    file { '/etc/init.d/beaver':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template("${module_name}/etc/init.d/beaver.${::osfamily}.erb"),
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
  } else {
    include ::systemd

    exec { 'switch-init-to-systemd':
      path    => '/bin:/sbin:/usr/bin:/usr/sbin',
      onlyif  => 'test -e /var/run/beaver.pid',
      command => '/etc/init.d/beaver stop || kill $(cat /var/run/beaver.pid) && rm -f /var/run/beaver.pid',
    }

    file { '/etc/init.d/beaver':
      ensure => absent,
    }

    file { '/lib/systemd/system/beaver.service':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      content => template("${module_name}/systemd/beaver.service.erb"),
      notify  => Exec['systemctl-daemon-reload'],
      before  => Service['beaver']
    }

    service { 'beaver':
      ensure  => $beaver::service_ensure,
      enable  => $beaver::service_enable,
      name    => $beaver::service_name,
      require => File['/lib/systemd/system/beaver.service']
    }
  }
}

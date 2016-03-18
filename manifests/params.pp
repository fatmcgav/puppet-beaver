# == Class: beaver
#
# This class is responsible for setting defaults.
#
#
# === Authors
#
# * Gavin Williams <mailto:fatmcgav@gmail.com>
#
class beaver::params {

  # Package defaults
  $package_name     = 'Beaver'
  $package_ensure   = 'present'
  $package_provider = 'pip'

  $service_ensure   = 'running'
  $service_enable   = true
  $service_name     = 'beaver'
  $service_pattern  = 'beaver'

  $format           = 'json'
  $respawn_delay    = 3
  $max_failure      = 7
  $queue_timeout    = 60
  $hostname         = $::fqdn
  $transport        = 'redis'
  $logstash_version = '0'
  $virtualenv       = '/opt/Beaver'

  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'Amazon', 'OracleLinux', 'SLC': {
      if versioncmp($::operatingsystemmajrelease, '7') >= 0 {
        $service_provider = 'systemd'
      } else {
        $service_provider = 'init'
      }
    }

    'Debian': {
      if versioncmp($::operatingsystemmajrelease, '8') >= 0 {
        $service_provider = 'systemd'
      } else {
        $service_provider = 'init'
      }
    }

    'Ubuntu': {
      if versioncmp($::operatingsystemmajrelease, '15') >= 0 {
        $service_provider = 'systemd'
      } else {
        $service_provider = 'init'
      }
    }

    default: {
      $service_provider   = 'systemd'
    }
  }

}

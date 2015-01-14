# == Class: beaver::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
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
#   class { 'beaver::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class beaver::package {

  #### Package management
  include python

  # action
  package { $beaver::package_name:
    ensure   => $beaver::package_ensure,
    provider => 'pip',
    require  => Class['python'],
  }

}

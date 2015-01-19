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

  $venv_ensure = $beaver::package_ensure ? {
    /^(present|absent)$/ => $beaver::package_ensure,
    default              => 'present',
  }

  # setting this absent, will automatically remove the packages :)
  python::virtualenv { $beaver::virtualenv:
    ensure     => $venv_ensure,
  }

  if $venv_ensure != 'absent' {

    $beaver_pkg = $beaver::package_ensure ? {
      /^(present|absent|latest)$/ => $beaver::package_name,
      default                     => "${beaver::package_name}==${beaver::package_ensure}",
    }

    ###
    # XXX THIS IS A TEMPORARY HACK UNTIL BEAVER 34.0.0 IS RELEASED
    # PLEAES REMOVE AFTERWARDS
    python::pip { 'python-daemon':
      ensure     => '1.6.1',
      virtualenv => $beaver::virtualenv,
    } ->
    python::pip { $beaver_pkg:
      ensure     => $venv_ensure,
      virtualenv => $beaver::virtualenv,
    }

    if $beaver::transport == 'zmq' {
      ###
      # XXX WHY DOES BEAVER DEPEND ON A VERSION OF PYZMQ THAT IS 12 VERSIONS
      # BEHIND THE CURRENT ONE?
      python::pip { 'pyzmq==2.1.11':
        ensure     => $venv_ensure,
        virtualenv => $beaver::virtualenv,
      }
    }
  }

}

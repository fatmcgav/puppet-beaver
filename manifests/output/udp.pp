# == Define: beaver::output::udp
#
#   send events to a udp host
#
# === Parameters
#
# [*host*]
#   The hostname to connect to.
#   Value type is string
#   This variable is mandatory
#
# [*port*]
#   The port to connect to
#   Value type is number
#   Default value: 9999
#   This variable is mandatory
#
# === Examples
#
#  beaver::output::udp{ 'udpout':
#    host => 'udphost'
#    port => 9999
#  }
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define beaver::output::udp (
  $host,
  $port,
) {

  validate_string($host)
  $opt_host = "udp_host: ${host}\n"

  validate_re($port, '^\d+$')
  $opt_port = "udp_port: ${port}\n"

  concat::fragment{ "output_udp_${title}":
    target  => '/etc/beaver/beaver.conf',
    content => "${opt_host}${opt_port}\n",
    order   => 20
  }
}

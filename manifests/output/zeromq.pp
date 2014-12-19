# == Define: beaver::output::zeromq
#
#   send events to a zeromq host
#
# === Parameters
#
# [*host*]
#   The hostname of your zeromq server ( only used with connect type )
#   Value type is string
#   This variable is optional
#
# [*port*]
#   The default port to connect
#   Value type is number
#   Default value: 2120
#   This variable is optional
#
# [*hwm*]
#   Zeromq HighWaterMark socket option
#   Value type is number
#   This variable is optional
#
# [*type*]
#   Run either as a client ( connect ) or server ( bind )
#   Value can be any of: "bind", "connect"
#   Default value: 'bind'
#   This variable is optional
#
# === Examples
#
#  Connect to remote zeromq host
#
#  beaver::output::zeromq{ 'zeromqout':
#    host => 'zeromqhost',
#    type => 'connect'
#  }
#
#  Start zeromq server
#
#  beaver::output::zeromq{ 'zeromqout':
#    type => 'bind'
#  }
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define beaver::output::zeromq(
  $host = undef,
  $port = 2120,
  $type = 'bind',
  $hwm  = undef,
) {

  validate_re($port, '^\d+$')
  validate_re($type, '^(bind|connect)$')

  if $type == 'connect' and !$host {
    fail('\'host\' variable is required when using the connect type')
  }

  if $hwm {
    validate_re($hwm, '^\d+$')
    $opt_hwm = "zeromq_hwm: ${hwm}\n"
  }

  if $host {
    validate_string($host)
  }

  $opt_url = $type? {
    'connect' => "zeromq_address: tcp://${host}:${port}\n",
    default   => "zeromq_address: tcp://*:${port}\n",
  }

  $opt_type = "zeromq_bind: ${type}\n"

  concat::fragment { "output_zeromq_${title}":
    target  => '/etc/beaver/beaver.conf',
    content => "${opt_url}${opt_type}${opt_hwm}\n",
    order   => 20
  }

}

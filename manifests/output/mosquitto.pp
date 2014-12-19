# == Define: beaver::output::mosquitto
#
#   send events to a mosquitto server
#
# === Parameters
#
# [*host*]
#   The hostname of your mosquitto server.
#   Value type is string
#   Default value: localhost
#   This variable is mandatory
#
# [*port*]
#   The default port to connect on.
#   Value type is number
#   Default value: 1883
#   This variable is optional
#
# [*clientid*]
#   Client ID in mosquitto
#   Value type is string
#   Default value: mosquitto
#   This variable is optional
#
# [*topic*]
#   Topic to publish to
#   Value type is string
#   Default value: /logstash
#   This variable is optional
#
# [*keepalive*]
#   mqtt keepalive ping
#   Value type is number
#   Default value: 60
#   This variable is optional
#
# === Examples
#
#  beaver::output::mosquitto { 'mosquitto_output':
#    host => 'mosquittohost'
#  }
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define beaver::output::mosquitto(
  $host,
  $port      = undef,
  $clientid  = undef,
  $keepalive = undef,
  $topic     = undef,
) {

  if $port {
    validate_re($port, '^\d+$')
    $opt_port = "mqtt_port: ${port}\n"
  }

  if $keepalive {
    validate_re($keepalive, '^\d+$')
    $opt_keepalive = "mqtt_keepalive: ${keepalive}\n"
  }

  if $host {
    validate_string($host)
    # XXX: is this supposed to be *not* separated by a space?
    $opt_host = "mqtt_host:${host}\n"
  }

  if $clientid {
    validate_string($clientid)
    $opt_clientid = "mqtt_clientid: ${clientid}\n"
  }

  if $topic {
    validate_string($topic)
    $opt_topic = "mqtt_topic: ${topic}\n"
  }

  $content = "${opt_host}${opt_port}${opt_clientid}${opt_topic}${opt_keepalive}\n"

  concat::fragment{ "output_mosquitto_${::fqdn}":
    target  => '/etc/beaver/beaver.conf',
    content => $content,
    order   => 20
  }
}

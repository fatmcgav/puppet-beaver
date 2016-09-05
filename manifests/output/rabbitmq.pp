# == Define: beaver::output::rabbitmq
#
#   send events to a rabbitmq server
#
# === Parameters
#
# [*host*]
#   The hostname of your rabbitmq server.
#   Value type is string
#   This variable is mandatory
#
# [*port*]
#   The default port to connect on.
#   Value type is number
#   Default value: 5672
#   This variable is optional
#
# [*vhost*]
#   Vhost in rabbitmq
#   Value type is string
#   Default value: /
#   This variable is optional
#
# [*username*]
#   Username for authentication
#   Value type is string
#   Default value: guest
#   This variable is optional
#
# [*password*]
#   Password for authentication
#   Value type is string
#   Default value: guest
#   This variable is optional
#
# [*queue*]
#   Queue name
#   Value type is string
#   Default value: logstash-queue
#
# [*queue_durable*]
#   Is the queue durable
#   Value can be any of: "1", "0"
#   Default value: 0
#   This variable is optional
#
# [*queue_ha*]
#   Should the queue be highly available
#   Value can be any of: "1", "0"
#   Default value: 0
#   This variable is optional
#
# [*exchange*]
#   Exchange name
#   Value type is string
#   Default value: logstash-exchange
#   This variable is optional
#
# [*exchange_durable*]
#   Is the exchange durable
#   Value can be any of: "1", "0"
#   Default value: 0
#   This variable is optional
#
# [*exchange_type*]
#   Exchange type
#   Value type is string
#   Default value: direct
#   This variable is optional
#
# [*key*]
#   The name of a rabbitmq key
#   Value type is string
#   Default value: logstash-key
#   This variable is optional
#
# === Examples
#
#  beaver::output::rabbitmq { 'rabbitmq_output':
#    host => 'rabbitmqhost'
#  }
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define beaver::output::rabbitmq(
  $host,
  $port             = undef,
  $vhost            = undef,
  $username         = undef,
  $password         = undef,
  $queue            = undef,
  $queue_durable    = undef,
  $queue_ha         = undef,
  $exchange         = undef,
  $exchange_durable = undef,
  $exchange_type    = undef,
  $key              = undef
) {

  validate_string($host)
  $opt_host = "rabbitmq_host: ${host}\n"

  if $port {
    validate_re("${port}", '^\d+$')
    $opt_port = "rabbitmq_port: ${port}\n"
  }

  if $vhost {
    validate_string($vhost)
    $opt_vhost = "rabbitmq_vhost: ${vhost}\n"
  }

  if $username {
    validate_string($username)
    $opt_username = "rabbitmq_username: ${username}\n"
  }

  if $password {
    validate_string($password)
    $opt_password = "rabbitmq_password: ${password}\n"
  }

  if $queue {
    validate_string($queue)
    $opt_queue = "rabbitmq_queue: ${queue}\n"
  }

  if ($queue_durable != '') {
    if ! ("${queue_durable}" in ['1', '0']) {
      fail("beaver::output::rabbitmq[${title}]: '${queue_durable}' is not a valid queue_durable parameter value")
    }
    $opt_queue_durable = "rabbitmq_queue_durable: ${queue_durable}\n"
  }

  if ($queue_ha != '') {
    if ! ("${queue_ha}" in ['1', '0']) {
      fail("beaver::output::rabbitmq[${title}]: '${queue_ha}' is not a valid queue_ha parameter value")
    }
    $opt_queue_ha = "rabbitmq_ha_queue: ${queue_ha}\n"
  }

  if $exchange {
    validate_string($exchange)
    $opt_exchange = "rabbitmq_exchange: ${exchange}\n"
  }

  if $exchange_type {
    validate_string($exchange_type)
    $opt_exchange_type = "rabbitmq_exchange_type: ${exchange_type}\n"
  }

  if $key {
    validate_string($key)
    $opt_key = "rabbitmq_key: ${key}\n"
  }

  if ($exchange_durable != '') {
    if ! ("${exchange_durable}" in ['1', '0']) {
      fail("beaver::output::rabbitmq[${title}]: '${exchange_durable}' is not a valid exchange_durable parameter value")
    }
    $opt_exchange_durable = "rabbitmq_exchange_durable: ${exchange_durable}\n"
  }

  $content = "${opt_host}${opt_port}${opt_vhost}${opt_username}${opt_password}${opt_queue}${opt_queue_durable}${opt_queue_ha}${opt_exchange}${opt_exchange_type}${opt_exchange_durable}${opt_key}\n"

  concat::fragment { "output_rabbitmq_${title}":
    target  => '/etc/beaver/beaver.conf',
    content => $content,
    order   => 20
  }
}

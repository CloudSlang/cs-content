########################################################################################################################
#!!
#! @description: This is a sample flow that demonstrates how to check the ping towards a provided host, using the local_ping operation from the utils folder.
#!
#! @input target_host: The target host to ping.
#! @input packet_count: The number of packets to send.
#!                      Default: ''
#!                      Optional
#! @input packet_size: The size of the ping packet.
#!                     Default: ''
#!                     Optional
#! @input timeout: The timeout in milliseconds for the Local Ping operation.
#!                 Note: When using timeout on an operating system belonging to SunOs family, the command will ignore
#!                 the rest of the options(packetSize, packetCount, ipVersion).
#!                 Default: '10000'
#!                 Optional
#! @input ip_version: IP version forced to the ping command executed on the target host. For Windows -4 or -6 parameters
#!                    will be added. On Linux, ping or ping6 will be used. For Solaris -A inet or -A inet6 parameters
#!                    will be added. For empty string the operation will decide what format to use if targetHost is an
#!                    ip literal; if targetHost is given as a hostname default 'ping' command will be used on each
#!                    operating system.Valid values: 4, 6, '' (empty string without quotes).
#!                    Default: ''
#!                    Optional
#!
#! @output return_result: The raw output of the ping command.
#! @output exception: In case of success response, this result is empty. In case of failure response, this result contains the java stack trace of the runtime exception.
#! @output packets_sent: The number of packets sent.
#! @output packets_received: The number of packets received.
#! @output percentage_packets_lost: The percentage of packets lost.
#! @output transmission_time_max: The maximum time taken for transmitting the packet.
#! @output transmission_time_min: The minimum time taken for transmitting the packet.
#! @output transmission_time_avg: The avg time taken for transmitting the packet.
#!!#
########################################################################################################################
namespace: io.cloudslang.base.samples.utils
flow:
  name: ping_target_host
  inputs:
    - target_host:
        prompt:
          type: text
        default: 127.0.0.1
    - packet_count: '4'
    - packet_size: '32'
    - timeout: '10000'
    - ip_version: '4'
  workflow:
    - local_ping:
        do:
          io.cloudslang.base.utils.local_ping:
            - target_host: '${target_host}'
            - packet_count: '${packet_count}'
            - packet_size: '${packet_size}'
            - timeout: '${timeout}'
            - ip_version: '${ip_version}'
        publish:
          - return_result
          - exception
          - packets_sent
          - packets_received
          - percentage_packets_lost
          - transmission_time_max
          - transmission_time_min
          - transmission_time_avg
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - exception: '${exception}'
    - packets_sent: '${packets_sent}'
    - packets_received: '${packets_received}'
    - percentage_packets_lost: '${percentage_packets_lost}'
    - transmission_time_max: '${transmission_time_max}'
    - transmission_time_min: '${transmission_time_min}'
    - transmission_time_avg: '${transmission_time_avg}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      local_ping:
        x: 100
        'y': 150
        navigate:
          83276f39-35d0-a13f-8dc2-d48c77b36233:
            targetId: 272a0f00-4cdf-a412-5ecb-ada34a9c5c71
            port: SUCCESS
    results:
      SUCCESS:
        272a0f00-4cdf-a412-5ecb-ada34a9c5c71:
          x: 400
          'y': 150

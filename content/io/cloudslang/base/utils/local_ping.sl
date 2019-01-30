#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: This operation runs a Ping command locally.
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
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure.
#! @output packets_sent: The number of packets sent.
#! @output packets_received: The number of packets received.
#! @output percentage_packets_lost: The percentage of packets lost.
#! @output transmission_time_min: The minimum time taken for transmitting the packet.
#! @output transmission_time_max: The maximum time taken for transmitting the packet.
#! @output transmission_time_avg: The average time taken for transmitting the packet.
#! @output exception: In case of success response, this result is empty. In case of failure response, this result
#!                    contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: The operation completed successfully.
#! @result FAILURE: An error occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation: 
  name: local_ping
  
  inputs: 
    - target_host    
    - targetHost: 
        default: ${get('target_host', '')}
        required: false 
        private: true 
    - packet_count:  
        required: false  
    - packetCount: 
        default: ${get('packet_count', '')}  
        required: false 
        private: true 
    - packet_size:  
        required: false  
    - packetSize: 
        default: ${get('packet_size', '')}  
        required: false 
        private: true 
    - timeout:
        default: '10000'
        required: false  
    - ip_version:  
        required: false  
    - ipVersion: 
        default: ${get('ip_version', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-utilities:0.1.4'
    class_name: 'io.cloudslang.content.utilities.actions.LocalPing'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - packets_sent: ${get('packetsSent', '')}
    - packets_received: ${get('packetsReceived', '')} 
    - percentage_packets_lost: ${get('percentagePacketsLost', '')} 
    - transmission_time_min: ${get('transmissionTimeMin', '')} 
    - transmission_time_max: ${get('transmissionTimeMax', '')} 
    - transmission_time_avg: ${get('transmissionTimeAvg', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE

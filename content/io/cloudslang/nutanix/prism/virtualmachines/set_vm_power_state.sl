#   Copyright 2024 Open Text
#   This program and the accompanying materials
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
#! @description: Sets the power state of a virtual machine. If the virtual machine is being powered on and no host is
#!               specified, the scheduler will pick a host with the most available CPU and memory that can support the
#!               virtual machine. Note that such a host may not be available. If the virtual machine is being power
#!               cycled, a different host can be specified to start it on. The logical timestamp can optionally be
#!               provided for consistency. If a logical timestamp is specified, then this operation will be rejected if
#!               the logical timestamp specified is not same as the value of the virtual machine logical timestamp.
#!               The logical timestamp can be obtained from the virtual machine object.
#!
#! @input hostname: The hostname for Nutanix Prism.
#! @input port: The port to connect to Nutanix Prism.
#!              Default: '9440'
#!              Optional
#! @input username: The username for Nutanix Prism.
#! @input password: The password for Nutanix Prism.
#! @input vm_uuid: The UUID of the virtual machine.
#! @input power_state: The desired power state of the virtual machine.
#!                     Allowed Values: "'ON', 'OFF', 'POWERCYCLE', 'RESET', 'PAUSE', 'SUSPEND', 'RESUME', 'SAVE',
#!                                      'ACPI_SHUTDOWN', 'ACPI_REBOOT'"
#! @input host_uuid: The UUID identifying the host on which the virtual machine is currently running. If virtual machine
#!                   is powered off, then this field is empty.
#!                   Optional
#! @input vm_logical_timestamp: The virtual logical timestamp of the virtual machine.
#!                              Optional
#! @input api_version: The api version for Nutanix Prism.
#!                     Default: 'v2.0'
#!                     Optional
#! @input proxy_host: Proxy server used to access the Nutanix Prism service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Nutanix Prism service.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server username.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if it
#!                         is not issued by a trusted certification authority.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible", the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from certificate authorities that you trust to identify
#!                        other parties. If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true', this input is ignored. Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period of inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, an existing open connection will be used and will be closed after execution.
#!                    Default: 'true'
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: '2'
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: '20'
#!                               Optional
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output exception: An error message in case there was an error while executing the request.
#! @output status_code: The HTTP status code for Nutanix Prism API request.
#! @output task_uuid: The UUID of the task that will be created in Nutanix Prism after submission of the API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.nutanix.prism.virtualmachines

operation:
  name: set_vm_power_state

  inputs:
    - hostname
    - port:
        required: false
    - username
    - password:
        sensitive: true
    - vm_uuid
    - vmUUID:
        default: ${get('vm_uuid', '')}
        required: false
        private: true
    - power_state
    - powerState:
        default: ${get('power_state', '')}
        required: false
        private: true
    - host_uuid:
        required: false
    - hostUUID:
        default: ${get('host_uuid', '')}
        required: false
        private: true
    - vm_logical_timestamp:
        required: false
    - vmLogicalTimestamp:
        default: ${get('vm_logical_timestamp', '')}
        required: false
        private: true
    - api_version:
        required: false
    - apiVersion:
        default: ${get('api_version', '')}
        required: false
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get('proxy_port', '')}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', '')}
        required: false
        private: true
        sensitive: true
    - trust_all_roots:
        required: false
    - trustAllRoots:
        default: ${get('trust_all_roots', '')}
        required: false
        private: true
    - x_509_hostname_verifier:
        required: false
    - x509HostnameVerifier:
        default: ${get('x_509_hostname_verifier', '')}
        required: false
        private: true
    - trust_keystore:
        required: false
    - trustKeystore:
        default: ${get('trust_keystore', '')}
        required: false
        private: true
    - trust_password:
        required: false
        sensitive: true
    - trustPassword:
        default: ${get('trust_password', '')}
        required: false
        private: true
        sensitive: true
    - connect_timeout:
        required: false
    - connectTimeout:
        default: ${get('connect_timeout', '')}
        required: false
        private: true
    - socket_timeout:
        required: false
    - socketTimeout:
        default: ${get('socket_timeout', '')}
        required: false
        private: true
    - keep_alive:
        required: false
    - keepAlive:
        default: ${get('keep_alive', '')}
        required: false
        private: true
    - connections_max_per_route:
        required: false
    - connectionsMaxPerRoute:
        default: ${get('connections_max_per_route', '')}
        required: false
        private: true
    - connections_max_total:
        required: false
    - connectionsMaxTotal:
        default: ${get('connections_max_total', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-nutanix-prism:1.0.9'
    class_name: 'io.cloudslang.content.nutanix.prism.actions.virtualmachines.SetVMPowerState'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - exception: ${get('exception', '')}
    - status_code: ${get('statusCode', '')}
    - task_uuid: ${get('taskUUID', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

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
#! @description: Creates a disk resource in the specified project using the data included as inputs.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input access_token: The access token from get_access_token.
#! @input network_name: Name of the Network. Provided by the client when the Network is created. The name must be
#!                      1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters
#!                      long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first
#!                      character must be a lowercase letter, and all following characters must be a dash, lowercase
#! @input network_description: The description of the new Network.
#!                             Optional
#! @input ip_v4_range: The range of internal addresses that are legal on this network. This range
#!                     is a CIDR specification, for example: 192.168.0.0/16. Provided by the client when the
#!                     network is created.
#!                     Optional
#! @input auto_create_subnetworks: When set to true, the network is created in 'auto subnet mode'. When set to false,
#!                                 the network is in 'custom subnet mode'.
#!                                 In 'auto subnet mode', a newly created network is assigned the default CIDR of
#!                                 10.128.0.0/9 and it automatically creates one subnetwork per region.
#!                                 Note: If <ipV4RangeInp> is set, then this input is ignored.
#!                                 Optional
#! @input async: Boolean specifying whether the operation to run sync or async.
#!               Valid: 'true', 'false'
#!               Default: 'true'
#!               Optional
#! @input timeout: The time, in seconds, to wait for a response if the async input is set to "false".
#!                 If the value is 0, the operation will wait until global operation progress is 100.
#!                 Valid: Any positive number including 0.
#!                 Default: '30'
#!                 Optional
#! @input polling_interval: The time, in seconds, to wait before a new request that verifies if the operation finished
#!                          is executed, if the async input is set to "false".
#!                          Valid values: Any positive number including 0.
#!                          Default: '1'
#!                          Optional
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input pretty_print: Whether to format the resulting JSON.
#!                      Valid: 'true', 'false'
#!                      Default: 'true'
#!                      Optional
#!
#! @output return_result: Contains the GlobalOperation resource, as a JSON object.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output global_operation_name: Contains the GlobalOperation name, if the returnCode is '0', otherwise it is empty.
#! @output network_name_out: The name of the newly created network if async is true, otherwise empty.
#! @output network_id: The id of the newly created network if async is true, otherwise empty.
#! @output status: The status of the operation if async is true, otherwise the status of the instance.
#!
#! @result SUCCESS: The request for the Network to be inserted was successfully sent.
#! @result FAILURE: An error occurred while trying to send the request.
#!
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.compute_engine.networks

operation:
  name: insert_network

  inputs:
    - project_id
    - projectId:
        default: ${get('project_id', '')}
        required: false
        private: true
    - access_token:
        sensitive: true
    - accessToken:
        default: ${get('access_token', '')}
        required: false
        private: true
        sensitive: true
    - network_name
    - networkName:
        default: ${get('network_name', '')}
        required: false
        private: true
    - network_description:
        default: ''
        required: false
    - networkDescription:
        default: ${get('network_description', '')}
        required: false
        private: true
    - auto_create_subnetworks:
        default: ''
        required: false
    - autoCreateSubnetworks:
        default: ${get('auto_create_subnetworks', '')}
        required: false
        private: true
    - ip_v4_range:
        default: ''
        required: false
    - ipV4Range:
        default: ${get('ip_v_4_range', '')}
        required: false
        private: true
    - async:
        default: 'true'
        required: false
    - timeout:
        default: '30'
        required: false
    - polling_interval:
        default: '1'
        required: false
    - pollingInterval:
        default: ${get('polling_interval', '')}
        required: false
        private: true
    - proxy_host:
        default: ''
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        default: '8080'
        required: false
    - proxyPort:
        default: ${get('proxy_port', '')}
        required: false
        private: true
    - proxy_username:
        default: ''
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        required: false
        private: true
    - proxy_password:
        default: ''
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', '')}
        required: false
        private: true
        sensitive: true
    - pretty_print:
        default: 'true'
        required: false
    - prettyPrint:
        default: ${get('pretty_print', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-google:0.4.2'
    class_name: io.cloudslang.content.google.actions.compute.compute_engine.networks.NetworksInsert
    method_name: execute

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}
    - global_operation_name: ${globalOperationName}
    - network_name_out: ${networkName}
    - network_id: ${networkId}
    - status

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

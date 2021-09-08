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
#! @description: Attaches a network interface to an instance.
#!               Note: The set of: <instance_id>, <networkInterface_id>, <device_index> are mutually exclusive with
#!                     <query_params> input. Please provide values EITHER FOR ALL: <instance_id>, <networkInterface_id>,
#!                     <device_index> inputs OR FOR <query_params> input.
#!                     As with all Amazon EC2 operations, the results might not appear immediately.
#!                     For Region-Endpoint correspondence information, check all the service endpoints available at:
#!                     http://docs.amazonwebservices.com/general/latest/gr/rande.html#ec2_region
#!
#! @input endpoint: Optional - Endpoint to which first request will be sent
#!                  Example: 'https://ec2.amazonaws.com'
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: 'AKIAIOSFODNN7EXAMPLE'
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
#! @input proxy_host: Optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: Optional - proxy server port. You must either specify values for both <proxy_host> and <proxy_port>
#!                    inputs or leave them both empty.
#! @input proxy_username: Optional - proxy server user name.
#! @input proxy_password: Optional - proxy server password associated with the <proxy_username> input value.
#! @input instance_id: Optional - ID of the instance that will be attached to the network interface. The instance
#!                     should be running (hot attach) or stopped (warm attach).
#!                     Example: 'i-abcdef12'
#! @input headers: Optional - string containing the headers to use for the request separated by new line (CRLF). The header
#!                 name-value pair will be separated by ":". Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: Accept:text/plain
#! @input query_params: Optional - string containing query parameters that will be appended to the URL. The names and the
#!                      values must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is "&" symbol. The query name will be separated from query value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#! @input network_interface_id: Optional - ID of the network interface to attach.
#!                              Example: 'eni-12345678'
#! @input device_index: Optional - ID of the device for the network interface attachment on the instance.
#!                      Example: '1'
#! @input version: Version of the web service to make the call against it.
#!                 Default: '2014-06-15'
#!                 Example: '2014-06-15'
#!
#! @output return_result: Outcome of the action in case of success, exception occurred otherwise
#! @output attachment_id_result: ID of the attachment in case of success
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: Success message
#! @result FAILURE: An error occurred when trying to attach network interface to specified instance
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.network

operation:
  name: attach_network_interface

  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
        required: false
    - identity
    - credential:
        sensitive: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxy_password:
        required: false
    - proxyPassword:
        default: ${get("proxy_password", "")}
        required: false
        private: true
    - instance_id:
        required: false
    - instanceId:
        default: ${get("instance_id", "")}
        required: false
        private: true
    - headers:
        default: ''
        required: false
    - query_params:
        required: false
    - queryParams:
        default: ${get("query_params", "")}
        required: false
        private: true
    - network_interface_id
    - networkInterfaceId:
        default: ${get("network_interface_id", "")}
        required: false
        private: true
    - device_index
    - deviceIndex:
        default: ${get("device_index", "")}
        private: true
    - version:
        default: '2014-06-15'
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.network.AttachNetworkInterfaceAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}
    - attachment_id_result: ${get("attachmentIdResult", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
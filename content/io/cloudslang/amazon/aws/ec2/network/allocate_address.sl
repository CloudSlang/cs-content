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
#! @description: Acquires an Elastic IP address.
#!               Note: An Elastic IP address is for use either in the EC2-Classic platform or in a VPC.
#!                     For more information, see Elastic IP Addresses in the Amazon Elastic Compute Cloud User Guide.
#!
#! @input endpoint: Optional - Endpoint to which the request will be sent
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: "AKIAIOSFODNN7EXAMPLE"
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
#! @input proxy_host: Optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#!                    Default: ''
#! @input proxy_port: Optional - Proxy server port. You must either specify values for both <proxy_host> and <proxy_port>
#!                    inputs or leave them both empty.
#!                    Default: ''
#! @input proxy_username: Optional - Proxy server user name.
#!                        Default: ''
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#!                        Default: ''
#! @input version: Version of the web service to make the call against it.
#!                 Example: '2014-06-15'
#!                 Default: '2014-06-15'
#! @input headers: Optional - String containing the headers to use for the request separated by new line (CRLF). The
#!                 header name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: Accept:text/plain
#!                 Default: ''
#! @input query_params: Optional - String containing query parameters that will be appended to the URL. The names and the
#!                      values must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is "&" symbol. The query name will be separated from query
#!                      value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#!                      Default: ''
#! @input domain: Optional - If set to "vpc" then allocates the address for use with instances in a VPC, otherwise for
#!                use with with instances in EC2 Classic way.
#!                Valid values: 'standard', 'vpc'
#!                Default: 'standard'
#!
#! @output return_result: Outcome of the action in case of success, exception occurred otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: Error message if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: Success message
#! @result FAILURE: An error occurred when trying to allocate new IP address
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.network

operation:
  name: allocate_address

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
        default: '8080'
        required: false
    - proxyPort:
        default: ${get("proxy_port", "")}
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
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        private: true
        sensitive: true
        required: false
    - version:
        default: '2014-06-15'
        required: false
    - headers:
        default: ''
        required: false
    - query_params:
        required: false
    - queryParams:
        default: ${get("query_params", "")}
        required: false
        private: true
    - domain:
        default: 'standard'
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.58'
    class_name: io.cloudslang.content.amazon.actions.network.AllocateAddressAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

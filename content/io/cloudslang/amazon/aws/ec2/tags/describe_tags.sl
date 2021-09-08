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
#! @description: This operation can be used to retrieve information about one or more EC2 tags, in XML format,
#!               that respect all the filter criterion.
#!
#! @input endpoint: Endpoint to which the request will be sent.
#!                  Default: 'https://ec2.amazonaws.com'
#!                  Optional
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: 'AKIAIOSFODNN7EXAMPLE'
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
#! @input proxy_host: Proxy server used to connect to Amazon API. If empty no proxy will be used.
#!                    Default: ''
#!                    Optional
#! @input proxy_port: Proxy server port. You must either specify values for both <proxy_host> and <proxy_port>
#!                    inputs or leave them both empty.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Default: ''
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Default: ''
#!                        Optional
#! @input version: Version of the web service to make the call against it.
#!                 Example: '2016-11-15'
#!                 Default: '2016-11-15'
#!                 Optional
#! @input headers: String containing the headers to use for the request separated by new line (CRLF). The header
#!                 name-value pair will be separated by ':'.
#!                 Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: Accept:text/plain
#!                 Default: ''
#!                 Optional
#! @input query_params: String containing query parameters that will be appended to the URL. The names and the
#!                      values must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is '&' symbol. The query name will be separated from query
#!                      value by '='.
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2'
#!                      Default: ''
#!                      Optional
#! @input delimiter: Delimiter that will be used to separate parameters in all of the inputs.
#!                   Default: ','
#!                   Optional
#! @input filter_key: The tag key.
#!                    Default: ''
#!                    Optional
#! @input filter_resource_id: The resource ID.
#!                            Default: ''
#!                            Optional
#! @input filter_resource_type: The resource type.
#!                              Valid values: customer-gateway, dhcp-options, image, instance, internet-gateway,
#!                              network-acl, network-interface, reserved-instances, route-table, security-group, snapshot,
#!                              spot-instances-request, subnet, volume, vpc, vpn-connection, vpn-gateway.
#!                              Default: ''
#!                              Optional
#! @input filter_value: The tag value.
#!                      Default: ''
#!                      Optional
#! @input max_results: The maximum number of results to return in a single call. This value can be between 5 and 1000.
#!                     To retrieve the remaining results, make another call with the returned NextToken value.
#!                     Default: ''
#!                     Format: integer
#!                     Example: '5'
#!                     Optional
#! @input next_token: The token to retrieve the next page of results.
#!                    Default: ''
#!                    Optional
#!
#! @output return_result: Outcome of the action in case of success, exception occurred otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: Error message if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The xml with existing tags that match the criterias was successfully retrieved.
#! @result FAILURE: An error occurred when trying to retrieve tags details.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.tags

operation:
  name: describe_tags

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
        private: true
        sensitive: true
        required: false
    - version:
        default: '2016-11-15'
        required: false
    - headers:
        default: ''
        required: false
    - query_params:
        required: false
    - queryParams:
        default: ${get('query_params', '')}
        required: false
        private: true
    - delimiter:
        default: ','
        required: false
    - filter_key:
        default: ''
        required: false
    - filterKey:
        default: ${get('filter_key', '')}
        required: false
        private: true
    - filter_resource_id:
        default: ''
        required: false
    - filterResourceId:
        default: ${get('filter_resource_id', '')}
        required: false
        private: true
    - filter_resource_type:
        default: ''
        required: false
    - filterResourceType:
        default: ${get('filter_resource_type', '')}
        required: false
        private: true
    - filter_value:
        default: ''
        required: false
    - filterValue:
        default: ${get('filter_value', '')}
        required: false
        private: true
    - max_results:
        default: ''
        required: false
    - maxResults:
        default: ${get('max_results', '')}
        required: false
        private: true
    - next_token:
        default: ''
        required: false
    - nextToken:
        default: ${get('next_token', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.tags.DescribeTagsAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
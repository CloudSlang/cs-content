#   Copyright 2023 Open Text
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
#! @description: Returns information about your Amazon virtual private clouds (VPC). You can filter the results to return information
#!               only about VPCs that match the criteria you specify.
#!
#! @input endpoint: Optional - Endpoint to which first request will be sent.
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: "AKIAIOSFODNN7EXAMPLE"
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
#! @input vpc_ids: Optional - The ID of the VPC. Can also pass a multiple vpc ids. 
#!                                   Example: "vpc-1234567890abcdef0"
#!                                   Default: ""
#! @input vpc_filter_names_string: Optional - String that contains one or more values that represents filters for the search.
#!                             For a complete list of valid filters see: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeVpcs.html
#!                             Example: "is-default,owner-id,state,tag,tag-key,vpc-id,cidr,
#!                                       cidr-block-association.cidr-block,cidr-block-association.association-id,cidr-block-association.state,
#!                                       dhcp-options-id,ipv6-cidr-block-association.ipv6-cidr-block,ipv6-cidr-block-association.ipv6-pool,ipv6-cidr-block-association.association-id,ipv6-cidr-block-association.state"
#!                             Default: ""
#! @input vpc_filter_values_string: Optional - String that contains one or more values that represents filters values.
#!                              For a complete list of valid filters see: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeVpcs.html
#!                              Default: ""
#! @input proxy_host: Optional - Proxy server used to access the provider services.
#! @input proxy_port: Optional - Proxy server port used to access the provider services.
#! @input proxy_username: Optional - proxy server user name.
#!                        Default: ''
#! @input proxy_password: Optional - proxy server password associated with the proxy_username.
#!                        input value.
#!                        Default: ''
#! @input headers: Optional - string containing the headers to use for the request separated
#!                 by new line (CRLF). The header name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616)
#!                 Examples: 'Accept:text/plain'
#!                 Default: ''
#! @input query_params: Optional - string containing query parameters that will be appended to
#!                      the URL. The names and the values must not be URL encoded because if
#!                      they are encoded then a double encoded will occur. The separator between
#!                      name-value pairs is "&" symbol. The query name will be separated from
#!                      query value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#!                      Default: ""
#! @input version: Version of the web service to made the call against it.
#!                 Example: "2016-11-15"
#!                 Default: "2016-11-15"
#! @input delimiter: Optional - delimiter that will be used
#!                   Default: ','
#!
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The list with existing VPCs with their description was successfully retrieved
#! @result FAILURE: An error occurred when trying to retrieve VPCs list and their descriptions.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.vpc

operation:
  name: describe_vpcs

  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
        required: false
    - identity
    - credential:
        sensitive: true
    - vpc_ids:
        required: false
    - vpcIds:
        default: ${get("vpc_ids", "")}
        required: false
        private: true
    - vpc_filter_names_string:
        required: false
    - vpcFilterNamesString:
        default: ${get("vpc_filter_names_string", "")}
        required: false
        private: true
    - vpc_filter_values_string:
        required: false
    - vpcFilterValuesString:
        default: ${get("vpc_filter_values_string", "")}
        required: false
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        default: "8080"
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
        required: false
        private: true
        sensitive: true
    - headers:
        required: false
    - query_params:
        required: false
    - queryParams:
        default: ${get("query_params", "")}
        required: false
        private: true
    - version:
        default: '2016-11-15'
        required: false
    - delimiter:
        default: ','
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.50-RC2'
    class_name: io.cloudslang.content.amazon.actions.vpc.DescribeVpcsAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

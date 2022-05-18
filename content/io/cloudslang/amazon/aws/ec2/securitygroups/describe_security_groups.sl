#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: Describes the security groups that you own. By default, this operation returns information about all of
#!               your security groups, but you can specify a list of group names or group IDs to restrict the results to
#!               only those specified.
#!
#! @input endpoint: Optional - Endpoint to which first request will be sent
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: "AKIAIOSFODNN7EXAMPLE"
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
#! @input security_group_ids_string: Optional - The IDs of the groups that you want to describe. This input can be used
#!                                   also for security groups in a nondefault VPC
#!                                   Example: "sg-01234567,sg-7654321,sg-abcdef01"
#!                                   Default: ""
#! @input security_group_names_string: Optional - The names of the groups that you want to describe. Only EC2-Classic
#!                                     and default VPC security groups can be referenced by name.
#!                                     Default: ""
#! @input proxy_host: Optional - Proxy server used to access the provider services
#! @input proxy_port: Optional - Proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Optional - proxy server user name.
#!                        Default: ''
#! @input proxy_password: Optional - proxy server password associated with the proxy_username
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
#! @input delimiter: Optional - delimiter that will be used
#!                   Default: ','
#! @input version: Version of the web service to made the call against it.
#!                 Example: "2016-11-15"
#!                 Default: "2016-11-15"
#! @input filter_names_string: Optional - String that contains one or more values that represents filters for the search.
#!                             For a complete list of valid filters see: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeSecurityGroups.html
#!                             Example: "description,group-id,group-name,ip-permission.cidr,ip-permission.from-port,
#!                                       ip-permission.group-id,ip-permission.group-name,ip-permission.protocol,
#!                                       ip-permission.to-port,ip-permission.user-id,owner-id,tag-key,tag-value,vpc-id"
#!                             Default: ""
#! @input filter_values_string: Optional - String that contains one or more values that represents filters values.
#!                              For a complete list of valid filters see: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeSecurityGroups.html
#!                              Default (describes all your security groups): ""
#! @input max_results: Optional - The maximum number of results to return in a single call. To retrieve the
#!                     remaining results, make another call with the returned NextToken value. This value can
#!                     be between 5 and 1000. You cannot specify this parameter and the instance IDs parameter
#!                     or tag filters in the same call.
#!                     Default: ""
#! @input next_token: Optional - The token to use to retrieve the next page of results. This value is null when
#!                    there are no more results to return.
#!                    Default: ""
#!
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The list with existing servers (instances) was successfully retrieved
#! @result FAILURE: An error occurred when trying to retrieve servers (instances) list
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.securitygroups

operation:
  name: describe_security_groups

  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
        required: false
    - identity
    - credential:
        sensitive: true
    - security_group_ids_string:
        required: false
    - securityGroupIdsString:
        default: ${get("security_group_ids_string", "")}
        required: false
        private: true
    - security_group_names_string:
        required: false
    - securityGroupNamesString:
        default: ${get("security_group_names_string", "")}
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
        default: '2016-09-15'
        required: false
    - delimiter:
        default: ','
        required: false
    - filter_names_string:
        required: false
    - filterNamesString:
        default: ${get("filter_names_string", "")}
        required: false
        private: true
    - filter_values_string:
        required: false
    - filterValuesString:
        default: ${get("filter_values_string", "")}
        required: false
        private: true
    - max_results:
        required: false
    - maxResults:
        default: ${get("max_results", "")}
        required: false
        private: true
    - next_token:
        required: false
    - nextToken:
        default: ${get("next_token", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.41-RC2'
    class_name: io.cloudslang.content.amazon.actions.securitygroups.DescribeSecurityGroupsAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

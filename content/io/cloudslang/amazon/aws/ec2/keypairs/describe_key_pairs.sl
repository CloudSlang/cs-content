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
#! @description: Describes the specified key pairs or all of your key pairs.
#!
#! @input endpoint: Optional - The endpoint to which requests are sent.
#!                  Examples:  ec2.us-east-1.amazonaws.com, ec2.us-west-2.amazonaws.com, ec2.us-west-1.amazonaws.com.
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: The Amazon Access Key ID.
#! @input credential: The Amazon Secret Access Key that corresponds to the Amazon Access Key ID.
#! @input proxy_host: Optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: Optional - Proxy server port. You must either specify values for both proxyHost and proxyPort
#!                    inputs or leave them both empty.
#!                    Default: '8080'
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxyUsername input value.
#! @input headers: Optional - String containing the headers to use for the request separated by new line (CRLF). The header name-value
#!                 pair will be separated by ':' (colon).
#!                 Format: Conforming with HTTP standard for headers (RFC 2616)
#!                 Example: 'Accept:text/plain'
#!                 Default: ''
#! @input query_params: Optional - String containing query parameters that will be appended to the URL. The names and the
#!                      values must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is '&' (ampersand) symbol. The query name will be separated from
#!                      query value by '=' (equal).
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2'
#!                      Default: ''
#! @input version: Optional - Version of the web service to made the call against it.
#!                 Example: '2016-11-15'
#!                 Default: ''
#! @input delimiter: Optional - Delimiter that will be used.
#! @input filter_names_string: Optional - String that contains one or more values that represents filters for
#!                             the search.
#!                             Example: " key-pair-id,key-name,fingerprint.
#!                             Default: ''
#! @input filter_values_string: Optional - String that contains one or more values that represents filters values.
#!                              Default: ''
#! @input max_results: Optional - The maximum number of results to return in a single call. To retrieve the
#!                                remaining results, make another call with the returned NextToken value. This value can
#!                                be between 5 and 1000. You cannot specify this parameter and the instance IDs parameter
#!                                or tag filters in the same call.
#!                                Default: ''
#! @input next_token: Optional - The token to use to retrieve the next page of results. This value is null when
#!                    there are no more results to return.
#!                    Default: ''
#!
#! @output return_result: contains the exception in case of failure, success message otherwise.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output exception: exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The subnet list described successfully.
#! @result FAILURE: An error has occurred while trying to describe an subnet.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.keypairs

operation:
  name: describe_key_pairs

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
        default: "8080"
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
        default: "2016-11-15"
        required: false
    - delimiter:
        required: false
        default: ','
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
    gav: 'io.cloudslang.content:cs-amazon:1.0.56-SNAPSHOT-10'
    class_name: 'io.cloudslang.content.amazon.actions.keypairs.DescribeKeyPairsAction'
    method_name: 'execute'

  outputs:
    - return_code: ${get('returnCode', '')}
    - return_result: ${get('returnResult', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

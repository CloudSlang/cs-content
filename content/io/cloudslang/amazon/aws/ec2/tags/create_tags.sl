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
#! @description: Adds or overwrites one or more tags for the specified Amazon EC2 resource/resources.
#!               Note: Each resource can have a maximum of 10 tags. Each tag consists of a key and Optional value. Tag
#!               keys must be unique per resource. For more information about tags, see Tagging Your Resources in the
#!               Amazon Elastic Compute Cloud User Guide. For more information about creating IAM policies that control
#!               users access to resources based on tags, see Supported Resource-Level Permissions for Amazon EC2 API
#!               Actions in the Amazon Elastic Compute Cloud User Guide.
#!
#! @input endpoint: Optional - Endpoint to which the request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: Amazon Access Key ID
#! @input credential: Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: Optional - Proxy server used to access the provider services
#! @input proxy_port: Optional - Proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input headers: Optional - String containing the headers to use for the request separated by new line (CRLF).
#!                 The header name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616)
#!                 Examples: 'Accept:text/plain'
#!                 Default: ''
#! @input query_params: Optional - String containing query parameters that will be appended to the URL. The names
#!                      and the values must not be URL encoded because if they are encoded then a double encoded
#!                      will occur. The separator between name-value pairs is "&" symbol. The query name will be
#!                      separated from query value by "=".
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2'
#!                      Default: ''
#! @input version: Version of the web service to make the call against it.
#!                 Example: '2016-04-01'
#!                 Default: '2016-04-01'
#! @input delimiter: Optional - Delimiter that will be used - Default: ','
#! @input key_tags_string: String that contains one or more key tags separated by delimiter.
#! @input value_tags_string: String that contains one or more tag values separated by delimiter.
#! @input resource_ids_string: String that contains Id's of one or more resources to tag.
#!                             Ex: 'ami-1a2b3c4d'
#!
#! @output return_result: Contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: Success message
#! @result FAILURE: An error occurred when trying to apply tags to resources
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.tags

operation:
  name: create_tags

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
        default: '2016-04-01'
        required: false
    - delimiter:
        default: ','
        required: false
    - key_tags_string
    - keyTagsString:
        default: ${key_tags_string}
        private: true
    - value_tags_string
    - valueTagsString:
        default: ${value_tags_string}
        private: true
    - resource_ids_string
    - resourceIdsString:
        default: ${resource_ids_string}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.tags.CreateTagsAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
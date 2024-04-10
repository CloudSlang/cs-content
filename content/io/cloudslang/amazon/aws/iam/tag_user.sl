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
#! @description: Adds one or more tags to an IAM user. If a tag with the same key name already exists, then that tag is overwritten with the new value..
#!
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS or IAM account.Example:
#!                       'AKIAIOSFODNN7EXAMPLE'
#! @input access_key: Secret access key associated with your Amazon AWS or IAM account.Example:
#!                    'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
#! @input username: Username.
#! @input tag_key_list: The list of key's of tags separated by comma(,)The length of the items in tag_key_list must be
#!                      equal with the length of the items in tag_value_list.
#!                      Optional
#! @input tag_value_list: The list of value's of tags separated by comma(,)The length of the items in tag_key_list must be
#!                        equal with the length of the items in tag_value_list.
#!                        Optional
#! @input proxy_host: Proxy server used to connect to Amazon API. If empty no proxy will be used.
#!                    Optional
#! @input proxy_port: Proxy server port. You must either specify values for both proxyHost and proxyPort inputs or leave
#!                    them both empty.Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.
#!                        Optional
#! @input connect_timeout: The amount of time to wait (in milliseconds) when initially establishing a connection before
#!                         giving up and timing out. Default: '10000'
#!                         Optional
#! @input execution_timeout: The amount of time (in milliseconds) to allow the client to complete the execution of an
#!                           API call. A value of '0' disables this feature.Default: '60000'
#!                           Optional
#! @input async: Whether to run the operation is async mode.Default: 'false'
#!               Optional
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output return_result: The full API response in case of success, or an error message in case of failure.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The product was successfully provisioned.
#! @result FAILURE: An error has occurred while trying to provision the product.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.iam

operation:
  name: tag_user

  inputs:
    - access_key_id
    - accessKeyID:
        default: ${get('access_key_id', '')}
        private: true
    - access_key:
        sensitive: true
    - accessKey:
        default: ${get('access_key', '')}
        private: true
        sensitive: true
    - username
    - tag_key_list:
        required: false
    - tag_value_list:
        required: false
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
    - connect_timeout:
        required: false
    - connectTimeout:
        default: ${get('connect_timeout', '')}
        required: false
        private: true
    - execution_timeout:
        required: false
    - executionTimeout:
        default: ${get('execution_timeout', '')}
        required: false
        private: true
    - async:
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.56-SNAPSHOT-11'
    class_name: 'io.cloudslang.content.amazon.actions.iam.TagUser'
    method_name: 'execute'

  outputs:
    - return_code: ${get('returnCode', '')}
    - return_result: ${get('returnResult', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

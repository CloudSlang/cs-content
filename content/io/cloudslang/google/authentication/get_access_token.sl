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
#! @description: This operation can be used to retrieve an access token to be used in subsequent google compute
#!               operations.
#!
#! @input json_token: Content of the Google Cloud service account JSON.
#! @input scopes: Scopes that you might need to request to access Google Compute APIs, depending on the level of access
#!                you need. One or more scopes may be specified delimited by the scopes_delimiter.
#!                Example: 'https://www.googleapis.com/auth/compute.readonly'
#!                Note: It is recommended to use the minimum necessary scope in order to perform the requests.
#!                For a full list of scopes see https://developers.google.com/identity/protocols/googlescopes#computev1
#! @input scopes_delimiter: Delimiter that will be used for the scopes input.
#!                          Default: ','
#!                          Optional
#! @input timeout: Timeout of the resulting access token, in seconds.
#!                 Default: '600'
#!                 Optional
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#!
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output return_result: Contains the access token as a string.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The access token has been successfully generated.
#! @result FAILURE: An error occurred while trying to get the access token.
#!!#
########################################################################################################################

namespace: io.cloudslang.google.authentication

operation:
  name: get_access_token
  
  inputs:
    - json_token:
        sensitive: true
    - jsonToken:
        default: ${get('json_token', '')}
        required: false
        private: true
        sensitive: true
    - scopes
    - scopes_delimiter:
        default: ''
        required: false
    - scopesDelimiter:
        default: ${get('scopes_delimiter', '')}
        required: false
        private: true
    - timeout:
        default: '600'
        required: false
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

  java_action:
    gav: 'io.cloudslang.content:cs-google:0.4.2'
    class_name: io.cloudslang.content.google.actions.authentication.GetAccessToken
    method_name: execute

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

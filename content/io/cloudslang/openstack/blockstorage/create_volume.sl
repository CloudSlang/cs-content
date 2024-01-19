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
#! @description: Creates an OpenStack volume.
#!
#! @input host: OpenStack machine host
#! @input identity_port: Optional - port used for OpenStack authentication
#!                       Default: '5000'
#! @input blockstorage_port: Optional - port used for creating volumes on OpenStack
#!                           Default: '8776'
#! @input tenant_name: name of OpenStack project where new volume will be created
#! @input volume_name: volume name
#! @input size: size of volume to be created
#! @input username: Optional - username used for URL authentication; for NTLM authentication
#!                  Format: 'domain\user'
#! @input password: Optional - password used for URL authentication
#! @input proxy_host: Optional - proxy server used to access OpenStack services
#! @input proxy_port: Optional - proxy server port used to access OpenStack services
#!                    Default: '8080'
#! @input proxy_username: Optional - username used when connecting to proxy
#! @input proxy_password: Optional - proxy server password associated with <proxy_username> input value
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file.
#!                        This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                        trustAllRoots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the TrustStore file.
#!                        If trust_all_roots is false and trustKeystore is empty,
#!                        trustPassword default will be supplied.
#!                        Default value: changeit
#! @input keystore: Optional - the pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if
#!                  trust_all_roots is 'true' this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: Optional - the password associated with the KeyStore file.
#!                           If trustAllRoots is false and keystore
#!                           is empty, keystorePassword default will be supplied.
#!                           Default value: ''
#!
#! @output return_result: response of operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '202'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by operation
#! @output volume_id: volume ID
#!
#! @result SUCCESS: volume was successfully created
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: authentication token cannot be obtained from authentication call response
#! @result GET_TENANT_ID_FAILURE: tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#! @result GET_AUTHENTICATION_FAILURE: authentication call fails
#! @result CREATE_VOLUME_FAILURE: volume could not be created
#! @result GET_VOLUME_ID_FAILURE: volume ID could not be retrieved
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack.blockstorage

imports:
  openstack: io.cloudslang.openstack
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: create_volume

  inputs:
    - host
    - identity_port: '5000'
    - blockstorage_port: '8776'
    - tenant_name
    - volume_name
    - size
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_keystore:
        default: ${get_sp('io.cloudslang.openstack.trust_keystore')}
        required: false
    - trust_password:
        default: ${get_sp('io.cloudslang.openstack.trust_password')}
        required: false
        sensitive: true
    - keystore:
        default: ${get_sp('io.cloudslang.openstack.keystore')}
        required: false
    - keystore_password:
        default: ${get_sp('io.cloudslang.openstack.keystore_password')}
        required: false
        sensitive: true

  workflow:
    - authentication:
        do:
          openstack.get_authentication_flow:
            - host
            - identity_port
            - tenant_name
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - token
          - tenant_id
          - return_result
          - error_message
        navigate:
          - SUCCESS: create_volume
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE

    - create_volume:
        do:
          rest.http_client_post:
            - url: ${'http://' + host + ':' + blockstorage_port + '/v2/' + tenant_id + '/volumes'}
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - headers: ${'X-AUTH-TOKEN:' + token}
            - content_type: 'application/json'
            - body: ${'{"volume":{"name":"' + volume_name + '","size":"' + size + '"}}'}
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: get_volume_id
          - FAILURE: CREATE_VOLUME_FAILURE

    - get_volume_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "volume,id"
        publish:
          - volume_id: ${return_result}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_VOLUME_ID_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - volume_id

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - CREATE_VOLUME_FAILURE
    - GET_VOLUME_ID_FAILURE

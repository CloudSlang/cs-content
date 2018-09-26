#   Copyright 2018, Micro Focus, L.P.
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
#! @description: Retrieves a list of all attributes of a given object.
#!
#! @input cmdb_host: The host running UCMDB.
#! @input cmdb_port: The UCMDB server port.
#! @input protocol: The protocol used to connect to the UCMDB server. HTTPS (TLS) is supported only by UCMDB version
#!                  9.x and 10.x.
#! @input username: The user name used for the UCMDB server connection.
#! @input password: The password associated with the 'username' input value.
#! @input object_id: The identifier of the object to query.
#! @input object_type: The type of the object to query.
#! @input attribute_list: A comma delimited list of attributes to retrieve.
#! @input cmdb_version: The major version number of the UCMDB server.
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL.
#!                         A certificate is trusted even if no trusted certification authority issued it.
#!                         Valid: 'true' or 'false'
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. The hostname
#!                                 verification system prevents communication with other hosts other than the ones you
#!                                 intended. This is done by checking that the hostname is in the subject alternative
#!                                 name extension of the certificate. This system is designed to ensure that, if an
#!                                 attacker(Man In The Middle) redirects traffic to his machine, the client will not
#!                                 accept the connection. If you set this input to "allow_all", this verification is
#!                                 ignored and you become vulnerable to security attacks. For the value
#!                                 "browser_compatible" the hostname verifier works the same way as Curl and Firefox.
#!                                 The hostname must match either the first CN, or any of the subject-alts. A wildcard
#!                                 can occur in the CN, and in any of the subject-alts. The only difference between
#!                                 "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with
#!                                 "browser_compatible" matches all subdomains, including "a.b.foo.com".
#!                                 From the security perspective, to provide protection against possible
#!                                 Man-In-The-Middle attacks, we strongly recommend to use "strict" option.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'.
#!                                 Default: 'strict'.
#!                                 Optional
#! @input keystore: The path to the KeyStore file. This file should contain a certificate the client is capable of
#!                  authenticating with on the uCMDB server.
#! @input keystore_password: The password associated with the keystore file.
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#!
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output return_result: The result of the execution.
#! @output attributes: The attributes and their values.
#!
#! @result FAILURE: The operation completed unsuccessfully.
#! @result SUCCESS: The operation completed as stated in the description.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.ucmdb
flow:
  name: get_object_attributes_by_id
  inputs:
    - cmdb_host
    - cmdb_port
    - protocol:
        default: http
        required: false
    - username:
        required: true
    - password:
        required: true
        sensitive: true
    - object_id
    - object_type
    - attribute_list:
        required: false
    - cmdb_version:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        required: false
    - keystore:
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - trust_keystore:
        required: false
    - trust_password:
        required: false
  workflow:
    - authenticate:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${protocol + '://' + cmdb_host + ':' + cmdb_port + '/rest-api/authenticate'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - keystore: '${keystore}'
            - keystore_password:
                value: '${keystore_password}'
                sensitive: true
            - source_file: null
            - body: "${'{\"username\": \"' + username + '\", \"password\": \"' + password + '\", \"clientContext\": 1 }'}"
            - content_type: application/json
            - method: POST
        publish:
          - json_token: '${return_result}'
          - error_message
          - return_code
          - return_result
        navigate:
          - SUCCESS: get_value
          - FAILURE: FAILURE
    - get_value:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${json_token}'
            - json_path: token
        publish:
          - token: '${return_result}'
          - return_result
          - return_code
          - error_message
        navigate:
          - SUCCESS: get_ci
          - FAILURE: FAILURE
    - get_ci:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${protocol + '://' + cmdb_host + ':' + cmdb_port + '/rest-api/dataModel/ci/' + object_id}"
            - auth_type: anonymous
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${keystore_password}'
                sensitive: true
            - keystore: '${keystore}'
            - keystore_password:
                value: '${keystore_password}'
                sensitive: true
            - headers: "${'Authorization: Bearer ' + token}"
            - content_type: application/json
            - method: GET
        publish:
          - ci_output: '${return_result}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: get_properties
          - FAILURE: FAILURE
    - get_properties:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${ci_output}'
            - json_path: properties
        publish:
          - ci_output: '${return_result}'
          - return_result
          - return_code
          - error_message
        navigate:
          - SUCCESS: parse_attribute_list
          - FAILURE: FAILURE
    - parse_attribute_list:
        do:
          io.cloudslang.microfocus.ucmdb.utility.parse_attribute_list:
            - attribute_list: '${attribute_list}'
            - json: '${ci_output}'
        publish:
          - attributes: '${attributes_list}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  outputs:
    - return_result
    - return_code
    - exception
    - attributes
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      authenticate:
        x: 40
        y: 126
        navigate:
          343b2945-5ecc-c12c-055a-a942d028d294:
            targetId: 58bcba2e-dac0-8b9d-0b56-157900c2f12d
            port: FAILURE
      get_value:
        x: 203
        y: 128
        navigate:
          89850a21-4c6f-cb95-12a9-a81090455e6a:
            targetId: 58bcba2e-dac0-8b9d-0b56-157900c2f12d
            port: FAILURE
      get_ci:
        x: 362
        y: 127
        navigate:
          189844a8-4892-7cc7-26ba-dc6b19f59efa:
            targetId: 58bcba2e-dac0-8b9d-0b56-157900c2f12d
            port: FAILURE
      get_properties:
        x: 522
        y: 127
        navigate:
          df82a75d-ec0d-e8c2-e5fc-4ffd2d86adb2:
            targetId: 58bcba2e-dac0-8b9d-0b56-157900c2f12d
            port: FAILURE
      parse_attribute_list:
        x: 706
        y: 128
        navigate:
          f83ea97d-1f1d-64aa-a36b-0465827f6696:
            targetId: ec4d30fa-0afc-f2cc-bc04-efccfea82d5a
            port: SUCCESS
          cd3ec36f-44c2-8c8f-536c-900a9fe253a8:
            targetId: 58bcba2e-dac0-8b9d-0b56-157900c2f12d
            port: FAILURE
    results:
      FAILURE:
        58bcba2e-dac0-8b9d-0b56-157900c2f12d:
          x: 362
          y: 485
      SUCCESS:
        ec4d30fa-0afc-f2cc-bc04-efccfea82d5a:
          x: 963
          y: 130

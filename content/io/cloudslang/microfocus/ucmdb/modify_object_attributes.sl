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
#! @description: Changes one or more attributes on an object.
#!               Notes: Due to the issue of UCMDB API, when integrate with UCMDB 9.0 or lower version,  if update the
#!                      value of an attribute which is not editable, the API will come back with successful status,
#!                      however the attribute won't get updated with the new value.
#!
#! @input cmdb_host: The host running UCMDB.
#! @input cmdb_port: The UCMDB server port.
#! @input protocol: The protocol used to connect to the UCMDB server. HTTPS (TLS) is supported only by UCMDB version 9.x
#!                  and 10.x.
#!                  Valid: 'http' or 'https'.
#!                  Default: 'http'.
#! @input username:  The user name used for the UCMDB server connection.
#! @input password: The password associated with the 'username' input value.
#! @input object_id: The identifier of the object to query.
#! @input object_type: The type of the object to query.
#! @input property_list: A property to set (name=value), The type of the property will be automatically determined.
#!                       Additional properties can be added by making extra prop inputs with a number appended, such
#!                       as prop1.
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Valid: 'true' or 'false'.
#!                         Default: 'false'.
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
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots
#!                        is 'true' this input is ignored. Format: Java KeyStore (JKS).
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false and
#!                        trust_keystore is empty, trust_password default will be supplied.
#!
#! @output return_result: The result of the execution.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output ci_update_summary: Summary result message from uCMDB about the updated CI's
#!
#! @result FAILURE: The operation completed unsuccessfully.
#! @result SUCCESS: The operation completed as stated in the description.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.ucmdb
flow:
  name: modify_object_attributes
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
    - property_list:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
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
        sensitive: true
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
            - body: "${'{\"username\": \"' + username + '\", \"password\": \"' + password + '\", \"clientContext\": 1 }'}"
            - content_type: application/json
            - method: POST
        publish:
          - json_token: '${return_result}'
          - return_result
          - return_code
          - error_message
        navigate:
          - SUCCESS: get_token_value
          - FAILURE: FAILURE
    - get_token_value:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${json_token}'
            - json_path: token
        publish:
          - token: '${return_result}'
          - return_result
        navigate:
          - SUCCESS: separate_attributes_list
          - FAILURE: FAILURE
    - modify_selected_attributes:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${protocol + '://' + cmdb_host + ':' + cmdb_port + '/rest-api/dataModel/ci/' + object_id}"
            - auth_type: anonymous
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
            - headers: "${'Authorization: Bearer ' + token}"
            - body: "${'{ \"ucmdbId\": \"' + object_id + '\",' + '\"type\": \"' + object_type + '\",' + ' \"properties\": {' + attributes + '}}'}"
            - content_type: application/json
            - method: PUT
        publish:
          - json_result: '${return_result}'
          - return_code
          - error_message
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
    - separate_attributes_list:
        do:
          io.cloudslang.microfocus.ucmdb.utility.separate_attributes_list:
            - prop_list: '${property_list}'
        publish:
          - attributes: '${attribute_list}'
          - return_result
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: modify_selected_attributes
  outputs:
    - return_result
    - return_code: '${return_code}'
    - exception: '${error_message}'
    - ci_update_summary: '${json_result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      authenticate:
        x: 23
        y: 148
      modify_selected_attributes:
        x: 503
        y: 150
        navigate:
          f492cb37-23e3-f0b5-fa76-35bd7ac6f485:
            targetId: 75769412-4f0b-c358-1d7f-b95f956c0094
            port: SUCCESS
      separate_attributes_list:
        x: 334
        y: 147
      get_token_value:
        x: 177
        y: 146
    results:
      SUCCESS:
        75769412-4f0b-c358-1d7f-b95f956c0094:
          x: 728
          y: 154

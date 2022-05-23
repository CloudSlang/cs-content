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
#! @description: This flow forms optional properties json.
#!
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Optional
#! @input proxy_username: Username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                         Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#! @input component_id: The service component ID.
#!                      Optional
#!
#! @output optional_properties_json: Returns optional properties json.
#!
#! @result SUCCESS: The flow completed successfully.
#! @result FAILURE: There was an error while trying to run every step of the flow.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.utils
flow:
  name: set_optional_properties_json
  inputs:
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - component_id:
        required: false
  workflow:
    - set_optional_properties_json:
        do:
          io.cloudslang.base.utils.do_nothing:
            - optional_properties_json: ''
        publish:
          - optional_properties_json
        navigate:
          - SUCCESS: check_proxy_host_empty
          - FAILURE: on_failure
    - check_proxy_host_empty:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${proxy_host}'
            - second_string: ''
        navigate:
          - SUCCESS: check_proxy_port_empty
          - FAILURE: add_proxy_host_to_json
    - add_proxy_host_to_json:
        do:
          io.cloudslang.base.utils.do_nothing:
            - optional_properties_json: "${optional_properties_json + ' {\"name\": \"proxy_host\", \"value\": \"' + proxy_host + '\", \"sensitive\": false},'}"
        publish:
          - optional_properties_json
        navigate:
          - SUCCESS: check_proxy_port_empty
          - FAILURE: on_failure
    - check_proxy_port_empty:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${proxy_port}'
            - second_string: ''
        navigate:
          - SUCCESS: check_proxy_user_name_empty
          - FAILURE: add_proxy_port_to_json
    - add_proxy_port_to_json:
        do:
          io.cloudslang.base.utils.do_nothing:
            - optional_properties_json: "${optional_properties_json + ' {\"name\": \"proxy_port\", \"value\": \"' + proxy_port + '\", \"sensitive\": false},'}"
        publish:
          - optional_properties_json
        navigate:
          - SUCCESS: check_proxy_user_name_empty
          - FAILURE: on_failure
    - check_proxy_user_name_empty:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${proxy_username}'
            - second_string: ''
        navigate:
          - SUCCESS: check_proxy_password_empty
          - FAILURE: add_proxy_username_to_json
    - add_proxy_username_to_json:
        do:
          io.cloudslang.base.utils.do_nothing:
            - optional_properties_json: "${optional_properties_json + ' {\"name\": \"proxy_username\", \"value\": \"' + proxy_username + '\", \"sensitive\": false},'}"
        publish:
          - optional_properties_json
        navigate:
          - SUCCESS: check_proxy_password_empty
          - FAILURE: on_failure
    - check_proxy_password_empty:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${proxy_password}'
            - second_string: ''
            - ignore_case: '${proxy_host}'
        navigate:
          - SUCCESS: check_trust_keystore_empty
          - FAILURE: add_proxy_password_to_json
    - add_proxy_password_to_json:
        do:
          io.cloudslang.base.utils.do_nothing:
            - optional_properties_json: "${optional_properties_json + ' {\"name\": \"proxy_password\", \"value\": \"' + proxy_password + '\", \"sensitive\": true},'}"
        publish:
          - optional_properties_json
        navigate:
          - SUCCESS: check_trust_keystore_empty
          - FAILURE: on_failure
    - check_trust_keystore_empty:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${trust_keystore}'
            - second_string: ''
        navigate:
          - SUCCESS: check_trust_password_empty
          - FAILURE: add_trust_keystore_to_json
    - add_trust_keystore_to_json:
        do:
          io.cloudslang.base.utils.do_nothing:
            - optional_properties_json: "${optional_properties_json + ' {\"name\": \"trust_keystore\", \"value\": \"' + trust_keystore + '\", \"sensitive\": false},'}"
        publish:
          - optional_properties_json
        navigate:
          - SUCCESS: check_trust_password_empty
          - FAILURE: on_failure
    - check_trust_password_empty:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${trust_password}'
            - second_string: ''
        navigate:
          - SUCCESS: check_component_id_empty
          - FAILURE: add_trust_password_to_json
    - add_trust_password_to_json:
        do:
          io.cloudslang.base.utils.do_nothing:
            - optional_properties_json: "${optional_properties_json + ' {\"name\": \"trust_password\", \"value\": \"' + trust_password + '\", \"sensitive\": true},'}"
        publish:
          - optional_properties_json
        navigate:
          - SUCCESS: check_component_id_empty
          - FAILURE: on_failure
    - add_component_id_to_json:
        do:
          io.cloudslang.base.utils.do_nothing:
            - optional_properties_json: "${optional_properties_json + ' {\"name\": \"component_id\", \"value\": \"' + component_id + '\", \"sensitive\": false},'}"
        publish:
          - optional_properties_json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - check_component_id_empty:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${component_id}'
            - second_string: ''
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: add_component_id_to_json
  outputs:
    - optional_properties_json
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      check_component_id_empty:
        x: 680
        'y': 200
        navigate:
          e2d32522-bd58-d83b-9f27-76280dabb2a0:
            targetId: 0b39bcfb-5352-3c4f-c5d0-2743eb919761
            port: SUCCESS
      add_proxy_host_to_json:
        x: 520
        'y': 40
      check_proxy_user_name_empty:
        x: 320
        'y': 360
      check_trust_password_empty:
        x: 680
        'y': 360
      add_component_id_to_json:
        x: 880
        'y': 200
        navigate:
          70978434-63ee-2d91-1a81-6c791a584b5e:
            targetId: 0b39bcfb-5352-3c4f-c5d0-2743eb919761
            port: SUCCESS
      add_trust_password_to_json:
        x: 880
        'y': 360
      check_trust_keystore_empty:
        x: 680
        'y': 560
      check_proxy_password_empty:
        x: 320
        'y': 560
      add_proxy_username_to_json:
        x: 520
        'y': 360
      set_optional_properties_json:
        x: 120
        'y': 40
      add_trust_keystore_to_json:
        x: 880
        'y': 560
      check_proxy_port_empty:
        x: 320
        'y': 200
      add_proxy_password_to_json:
        x: 520
        'y': 560
      add_proxy_port_to_json:
        x: 520
        'y': 200
      check_proxy_host_empty:
        x: 320
        'y': 40
    results:
      SUCCESS:
        0b39bcfb-5352-3c4f-c5d0-2743eb919761:
          x: 760
          'y': 40

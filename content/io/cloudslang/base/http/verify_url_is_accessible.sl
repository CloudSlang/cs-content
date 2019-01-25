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
#! @description: Checks if a url is accessible.
#!
#! @input url: The url to be checked for accessibility.
#! @input attempts: Attempts to reach host.
#! @input time_to_sleep: Time in seconds to wait between attempts.
#! @input content_type: Optional - Content type that should be set in the request header, representing the MIME-type
#!                      of the data in the message body.
#!                      Default: 'application/json'
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Default: ''
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input keystore: Optional - The pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Format: Java KeyStore (JKS)
#!                  Default: ''
#! @input keystore_password: Optional - The password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Default: ''
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!
#! @output output_message: Timeout exceeded and url was not accessible
#! @output return_code: '0' if success, '-1' otherwise
#!
#! @result SUCCESS: URL is accessible
#! @result FAILURE: URL is not accessible
#!!#
########################################################################################################################

namespace: io.cloudslang.base.http

imports:
  math: io.cloudslang.base.math
  rest: io.cloudslang.base.http
  utils: io.cloudslang.base.utils

flow:
  name: verify_url_is_accessible

  inputs:
    - url
    - attempts: '1'
    - time_to_sleep:
        default: '1'
        required: false
    - content_type:
        default: 'application/json'
    - trust_keystore:
        default: ${get_sp('io.cloudslang.base.network.trust_keystore')}
        required: false
    - trust_password:
        default: ${get_sp('io.cloudslang.base.network.trust_password')}
        required: false
        sensitive: true
    - keystore:
        default: ${get_sp('io.cloudslang.base.network.keystore')}
        required: false
    - keystore_password:
        default: ${get_sp('io.cloudslang.base.network.keystore_password')}
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - http_get:
        do:
          rest.http_client_get:
            - url
            - content_type
            - connect_timeout: '20'
            - trust_all_roots: 'false'
            - x_509_hostname_verifier: 'strict'
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - proxy_host
            - proxy_port
        publish:
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: check_if_timed_out

    - check_if_timed_out:
         do:
            math.compare_numbers:
              - value1: ${attempts}
              - value2: '0'
         navigate:
           - GREATER_THAN: wait
           - EQUALS: FAILURE
           - LESS_THAN: FAILURE

    - wait:
        do:
          utils.sleep:
              - seconds: ${time_to_sleep}
              - attempts
        publish:
          - attempts: ${str(int(attempts) - 1)}
        navigate:
          - SUCCESS: http_get
          - FAILURE: FAILURE

  outputs:
    - output_message: ${"Url is accessible" if return_code == '0' else "Url is not accessible"}
    - return_code

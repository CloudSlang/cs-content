#   (c) Copyright 2021 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: This flow downloads an object from a specified bucket location in the Google Storage Buckets section
#!
#! @input access_token: The access_token as string.
#! @input bucket_id: The bucket id for which to initiate the session.
#! @input destination_file: Absolute path of a file on disk where the entity returned by the response will be
#!                          saved to.
#! @input object_name: The object name from the Google Storage Bucket
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: User name used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Format: Java KeyStore (JKS)
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Optional
#! @input connect_timeout: Time in seconds to wait for a connection to be established.
#!                         Default: '0'
#!                         Optional
#! @input socket_timeout: Time in seconds to wait for data to be retrieved.
#!                        Default: '0'
#!                        Optional
#!
#! @output return_result: Response of the operation.
#! @output error_message: Return_result when the return_code is non-zero (e.g. network or other failure).
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!
#! @result SUCCESS: The object has been downloaded from the Google Storage.
#! @result FAILURE: Something went wrong and the object has not been downloaded.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.storage.objects

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: download_object

  inputs:
    - access_token
    - bucket_id
    - destination_file
    - object_name
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_keystore:
        default: ''
        required: false
    - trust_password:
        required: false
    - keystore:
        default: ''
        required: false
    - keystore_password:
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false

  workflow:
    - download_file:
        do:
          http.http_client_action:
            - url: "${'https://www.googleapis.com/download/storage/v1/b/' + bucket_id + '/o/' + object_name + '?alt=media}"
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - connect_timeout
            - socket_timeout
            - content_type: application/json
            - headers: "${'Authorization: Bearer ' + access_token}"
            - destination_file
            - method: "GET"
        publish:
          - return_result
          - return_code
          - error_message
          - status_code
          - response_headers


  outputs:
    - return_result
    - return_code
    - status_code
    - error_message
    - response_headers

  results:
    - SUCCESS
    - FAILURE
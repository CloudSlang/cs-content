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
#! @description: This flow uploads a provided file at a specified bucket location in the Google Storage Buckets section
#!
#! @input access_token: The access_token as string.
#! @input bucket_id: The bucket id for which to initiate the session.
#! @input source_file: The actual file to be uploaded.
#! @input file_name: The file name to be displayed on the Google Storage Bucket
#!                   Optional
#!                   Default: taken from init_upload_session as "myName"
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
#! @output file_id: The file id of the newly uploaded file.
#! @output file_link: The URL of the newly uploaded file.
#! @output return_result: If successful (status_code = 200), it contains a storage object
#!                        or the error message otherwise.
#! @output error_message: The error message from the Google response or the error message when return_code = '-1'.
#! @output return_code: '0' if target server is reachable, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!
#! @result SUCCESS: The provided file has been uploaded to the Google Storage.
#! @result FAILURE: Something went wrong and the file has not been uploaded.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.storage.objects

imports:
  http: io.cloudslang.base.http
  gcstorageutils: io.cloudslang.google.storage.utils
  json: io.cloudslang.base.json

flow:
  name: upload_object

  inputs:
    - access_token
    - bucket_id
    - source_file
    - file_name:
        required: false
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
    - get_upload_id:
        do:
          gcstorageutils.init_upload_session:
            - access_token
            - bucket_id
            - file_name
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
        publish:
          - upload_id
          - return_result
          - return_code
          - error_message
          - status_code
          - response_headers
        navigate:
          - SUCCESS: upload_file
          - FAILURE: on_failure
    - upload_file:
        do:
          http.http_client_put:
            - url: "${'https://www.googleapis.com/upload/storage/v1/b/' + bucket_id + '/o?uploadType=resumable&upload_id=' + upload_id}"
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
            - source_file
        publish:
          - return_result
          - return_code
          - error_message
          - status_code
          - response_headers
        navigate:
          - SUCCESS: get_file_id
          - FAILURE: on_failure

    - get_file_id:
        do:
          json.json_path_query:
            - json_object: '${return_result}'
            - json_path: .id
        publish:
          - file_id: "${''.join( c for c in return_result if  c not in '[]\"' )}"
        navigate:
          - SUCCESS: get_file_link
          - FAILURE: on_failure

    - get_file_link:
        do:
          json.json_path_query:
            - json_object: '${return_result}'
            - json_path: .selfLink
        publish:
          - file_link: "${''.join( c for c in return_result if  c not in '[]\"' )}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  outputs:
    - file_id
    - file_link
    - return_result
    - return_code
    - status_code
    - error_message

  results:
    - SUCCESS
    - FAILURE
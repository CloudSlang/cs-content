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
#! @description: Initiates a resumable upload session.
#!               For more details consult: https://cloud.google.com/storage/docs/json_api/v1/how-tos/resumable-upload.
#!
#! @input access_token: The access_token as string.
#! @input bucket_id: The bucket id for which to initiate the session.
#! @input file_name: Name to be used for the item to be uploaded.
#!                   Optional
#!                   Default: myName
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
#! @output upload_id: The id of the upload session parsed from the Location section in the response_headers
#! @output return_result: If successful (status_code = 200), it contains the entire result of the operation
#!                        or the error message otherwise.
#! @output error_message: The error message from the Google response or the error message when return_code = '-1'.
#! @output return_code: '0' if target server is reachable, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!
#! @result SUCCESS: An upload session has been properly initialized.
#! @result FAILURE: Something went wrong while trying to initialize the upload session.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.storage.utils

imports:
  http: io.cloudslang.base.http
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json

flow:
  name: init_upload_session

  inputs:
    - access_token
    - bucket_id
    - file_name:
        default: 'myName'
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
    - initialize_session:
        do:
          http.http_client_post:
            - url: "${'https://www.googleapis.com/upload/storage/v1/b/' + bucket_id + '/o?uploadType=resumable'}"
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
            - content_type: application/json; charset=UTF-8
            - headers: "${'Authorization: Bearer ' + access_token}"
            - body: "${'{\"name\": \"' + file_name + '\"}'}"
        publish:
          - return_result
          - return_code
          - error_message
          - status_code
          - response_headers
        navigate:
          - SUCCESS: get_upload_id
          - FAILURE: get_message

    - get_upload_id:
        do:
          lists.get_by_index:
            - list: ${response_headers}
            - delimiter: '\r\n'
            - index: '0'
        publish:
          - upload_id: ${return_result[22:200]}
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

    - get_message:
        do:
          json.json_path_query:
            - json_object: '${return_result}'
            - json_path: .message
        publish:
          - error_message: "${''.join( c for c in return_result if  c not in '[]\"' )}"
        navigate:
          - SUCCESS: on_failure
          - FAILURE: on_failure

  outputs:
    - upload_id
    - return_result
    - return_code
    - status_code
    - error_message
    - response_headers

  results:
    - SUCCESS
    - FAILURE
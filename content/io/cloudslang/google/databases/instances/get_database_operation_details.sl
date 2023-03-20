#   (c) Copyright 2023 Micro Focus, L.P.
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
#! @description: This operation is used to retrieve the database operation details.
#!
#! @input access_token: The authorization token for google cloud.
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input name: The name of the database instance
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: '..JAVA_HOME/java/lib/security/cacerts'
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#!
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output status: The current current state of the database instance.
#! @output self_link: The URI of this resource.
#!
#! @result SUCCESS: The databse operation details were found and successfully retrieved.
#! @result FAILURE: The database operation details were not found or some inputs were given incorrectly
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases.instances
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: get_database_operation_details
  inputs:
    - access_token:
        sensitive: true
    - project_id:
        sensitive: true
    - name
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
  workflow:
    - api_to_get_operation_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://sqladmin.googleapis.com/v1/projects/'+project_id+'/operations/'+name}"
            - auth_type: anonymous
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - headers: "${'Authorization: '+access_token}"
            - content_type: application/json
            - worker_group: '${worker_group}'
            - self_link: '${self_link}'
            - name: '${name}'
        publish:
          - database_json: '${return_result}'
        navigate:
          - SUCCESS: get_operation_details
          - FAILURE: on_failure
    - get_operation_details:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.databeses.utils.get_operation_details:
            - instance_json: '${database_json}'
        publish:
          - status
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - return_result
    - status_code
    - status
    - self_link
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_operation_details:
        x: 520
        'y': 240
        navigate:
          4fc9a99b-5449-11ed-03a7-41dc87584814:
            targetId: 8b36ac92-0640-ddc4-874b-c676765a6572
            port: SUCCESS
      api_to_get_operation_details:
        x: 320
        'y': 240
    results:
      SUCCESS:
        8b36ac92-0640-ddc4-874b-c676765a6572:
          x: 760
          'y': 240


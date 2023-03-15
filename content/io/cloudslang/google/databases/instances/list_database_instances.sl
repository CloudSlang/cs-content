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
#! @description: This operation is used to retrieve the list database instance details.
#!
#! @input access_token: The authorization token for google cloud.
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
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
#! @output instances_json: A JSON list containing the instance information.
#! @output list_database_instance_names: List of database instance names.
#!
#! @result SUCCESS: The list of database instance details successfully retrieved.
#! @result FAILURE: The list of database instance details were not found or some inputs were given incorrectly
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases.instances
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: list_database_instances
  inputs:
    - access_token:
        sensitive: true
    - project_id:
        sensitive: true
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
    - api_to_get_database_instances:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://sqladmin.googleapis.com/v1/projects/'+project_id+'/instances/'}"
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
        publish:
          - return_result
          - status_code
        navigate:
          - SUCCESS: set_success_message
          - FAILURE: on_failure
    - set_success_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: Information about the DB Instances has been successfully retrieved.
            - instances_json: '${return_result}'
        publish:
          - return_result: '${message}'
          - instances_json
        navigate:
          - SUCCESS: equals
          - FAILURE: on_failure
    - list_database_instance_names:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${instances_json}'
            - json_path: '$.items[*].name'
        publish:
          - list_database_instance_names: "${return_result.lstrip(\"[\"). rstrip(\"]\").replace(\"\\\"\",\"\")}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - equals:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.equals:
            - json_input1: '${instances_json}'
            - json_input2: '{}'
        navigate:
          - EQUALS: SUCCESS
          - NOT_EQUALS: list_database_instance_names
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - instances_json
    - list_database_instance_names
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      api_to_get_database_instances:
        x: 160
        'y': 200
      set_success_message:
        x: 360
        'y': 200
      list_database_instance_names:
        x: 520
        'y': 200
        navigate:
          351656e9-48ce-5ca2-75e1-1fdff14cea93:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      equals:
        x: 520
        'y': 400
        navigate:
          e849d501-6516-421c-51d2-809f255e17b8:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: EQUALS
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 720
          'y': 200

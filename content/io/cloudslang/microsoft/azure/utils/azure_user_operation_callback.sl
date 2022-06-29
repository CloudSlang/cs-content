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
#! @description: This operation executes azure user operations.
#!
#! @input component_id: The service component ID.
#! @input service_instance_id: The ID of the service instance.
#! @input on_behalf_of_user: The    login name of the user on behalf of whom the service is being requested.
#! @input action_name: The public action name.
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output return_result: Information about the user operation execution.
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: If there is any error while running the flow, it will be populated, empty otherwise
#!
#! @result FAILURE: There was an error while trying to run every step of the flow.
#! @result SUCCESS: The flow completed successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.utils
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  flow: io.cloudslang.base.utils
  auth: io.cloudslang.microsoft.azure.authorization
  vm: io.cloudslang.microsoft.azure.compute.virtual_machines
flow:
  name: azure_user_operation_callback
  inputs:
    - component_id:
        required: true
    - service_instance_id
    - on_behalf_of_user
    - action_name
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - search_and_replace:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_uri')}"
            - text_to_replace: dnd/rest
            - replace_with: auth/authentication-endpoint/authenticate/token?TENANTID=
            - dnd_tenant_id: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user').split(\"/\")[0]}"
            - service_instance_id: '${service_instance_id}'
            - component_id: '${component_id}'
            - on_behalf_of_user: '${on_behalf_of_user}'
            - action_name: '${action_name}'
        publish:
          - auth_endpoint: '${replaced_string + dnd_tenant_id}'
          - dnd_tenant_id
          - action_name
        navigate:
          - SUCCESS: get_auth_token_api_call
          - FAILURE: on_failure
    - get_auth_token_api_call:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${auth_endpoint}'
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
            - trust_keystore: "${get_sp('io.cloudslang.microfocus.content.trust_keystore')}"
            - trust_password:
                value: "${get_sp('io.cloudslang.microfocus.content.trust_password')}"
                sensitive: true
            - connect_timeout: "${get_sp('io.cloudslang.microfocus.content.connect_timeout')}"
            - socket_timeout: "${get_sp('io.cloudslang.microfocus.content.socket_timeout')}"
            - body: "${'{\"login\": \"' + get_sp('io.cloudslang.microfocus.content.dnd_rest_user').split(\"/\")[1] + '\", \"password\": \"'+ get_sp('io.cloudslang.microfocus.content.dnd_rest_password') +'\"}'}"
            - content_type: application/json
        publish:
          - auth_token: '${return_result}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: get_user_operations_api_call
          - FAILURE: on_failure
    - get_user_operations_api_call:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('io.cloudslang.microfocus.content.dnd_api_uri') + '/api/v1/'+ dnd_tenant_id + '/instance/'+service_instance_id+'/topology/'+component_id+'/publicActions?OnBehalfOfUser='+on_behalf_of_user}"
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
            - trust_keystore: "${get_sp('io.cloudslang.microfocus.content.trust_keystore')}"
            - trust_password:
                value: "${get_sp('io.cloudslang.microfocus.content.trust_password')}"
                sensitive: true
            - headers: "${'X-Auth-Token:' + auth_token}"
            - content_type: application/json
        publish:
          - user_operations_json: '${return_result}'
          - error_message
        navigate:
          - SUCCESS: json_path_query_action_id
          - FAILURE: on_failure
    - json_body_to_execute_operation:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - json_body: "${'{\"actionId\": \"' + action_id + '\"}'}"
        publish:
          - action_body: '${json_body}'
        navigate:
          - SUCCESS: execute_user_operation_api_call
          - FAILURE: on_failure
    - execute_user_operation_api_call:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('io.cloudslang.microfocus.content.dnd_api_uri') + '/api/v1/'+dnd_tenant_id+'/instance/'+service_instance_id+'/topology/'+component_id+'/publicAction/execute?OnBehalfOfUser='+on_behalf_of_user}"
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
            - trust_keystore: "${get_sp('io.cloudslang.microfocus.content.trust_keystore')}"
            - trust_password:
                value: "${get_sp('io.cloudslang.microfocus.content.trust_password')}"
                sensitive: true
            - connect_timeout: "${get_sp('io.cloudslang.microfocus.content.connect_timeout')}"
            - socket_timeout: "${get_sp('io.cloudslang.microfocus.content.socket_timeout')}"
            - headers: "${'X-Auth-Token:' + auth_token}"
            - body: '${action_body}'
            - content_type: application/json
        publish:
          - return_result
          - status_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - format_action_id:
        do:
          io.cloudslang.base.strings.remove:
            - origin_string: '${action_id}'
            - text: '"'
        publish:
          - action_id: '${new_string}'
        navigate:
          - SUCCESS: json_body_to_execute_operation
    - json_path_query_action_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${user_operations_json}'
            - json_path: "${'$.resources[*].actions[?(@.displayName==\"'+action_name+'\")].id'}"
        publish:
          - action_id: '${return_result.strip("[").strip("]")}'
        navigate:
          - SUCCESS: format_action_id
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - return_code
    - error_message
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      search_and_replace:
        x: 40
        'y': 120
      get_auth_token_api_call:
        x: 200
        'y': 120
      get_user_operations_api_call:
        x: 40
        'y': 280
      json_body_to_execute_operation:
        x: 360
        'y': 280
      execute_user_operation_api_call:
        x: 520
        'y': 120
        navigate:
          41d28cdd-671c-7478-2f3a-fd8b137dc14b:
            targetId: 0560f86a-123a-0400-0108-c8a7469e2db8
            port: SUCCESS
      format_action_id:
        x: 360
        'y': 120
      json_path_query_action_id:
        x: 200
        'y': 280
    results:
      SUCCESS:
        0560f86a-123a-0400-0108-c8a7469e2db8:
          x: 720
          'y': 120

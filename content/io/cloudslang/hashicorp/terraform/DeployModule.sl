namespace: io.cloudslang.hashicorp.terraform
flow:
  name: DeployModule
  inputs:
    - auth_token:
        default: ********
        sensitive: true
    - organization_name: cypherorg
    - workspace_name:
        default: testws
        required: true
    - workspace_description:
        default: test workspace
        required: false
    - vcs_repo_id:
        default: soumyanayak71/terraform-azurerm-resourcegroup
        required: false
    - working_directory:
        required: false
    - variable_category:
        required: false
    - auto_apply:
        default: 'false'
        required: false
    - trigger_prefixes:
        required: false
    - queue_all_runs:
        required: false
    - speculative_enabled:
        required: false
    - ingress_submodules:
        required: false
    - vcs_branch_name:
        required: false
    - terraform_version:
        required: false
    - run_message:
        default: test message
        required: false
    - is_destroy:
        default: 'false'
        required: false
    - sensitive:
        required: false
    - hcl:
        required: false
    - run_comment:
        default: test
        required: false
    - variables_json:
        default: '[{"propertyName":"tenant_id","propertyValue":"6002e264-31f7-43d3-a51e-9ed1ba9ca689","HCL":false,"Category":"terraform"},{"propertyName":"client_id","propertyValue":"eee76a2b-c83a-48ac-951d-dbf87e166d77","HCL":false,"Category":"terraform"},{"propertyName":"subscription_id","propertyValue":"d20eaed0-0b36-44eb-acff-7ae3f080cd9a","HCL":false,"Category":"terraform"},{"propertyName":"name","propertyValue":"terrrrrargrp","HCL":false,"Category":"terraform"},{"propertyName":"tags","propertyValue":"Production","HCL":false,"Category":"terraform"},{"propertyName":"location","propertyValue":"West US","HCL":false,"Category":"terraform"},{"propertyName":"CONFIRM_DESTROY","propertyValue":"1","HCL":false,"Category":"env"}]'
        required: false
    - sensitive_variables_json:
        default: ********
        required: false
        sensitive: true
    - proxy_host:
        default: web-proxy.in.softwaregrp.net
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_all_roots:
        required: false
    - x_509_hostname_verifier:
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false
    - keep_alive:
        default: 'true'
        required: false
    - connections_max_per_route:
        required: false
    - connections_max_total:
        required: false
    - response_character_set:
        required: false
  workflow:
    - list_o_auth_client:
        do:
          io.cloudslang.hashicorp.terraform.actions.list_o_auth_client:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - organization_name: '${organization_name}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - oauth_token_id
        navigate:
          - SUCCESS: create_workspace
          - FAILURE: on_failure
    - create_workspace:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.create_workspace:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - organization_name: '${organization_name}'
            - workspace_name: '${workspace_name}'
            - workspace_description: '${workspace_description}'
            - auto_apply: '${auto_apply}'
            - file_triggers_enabled: '${file_triggers_enabled}'
            - working_directory: '${working_directory}'
            - trigger_prefixes: '${trigger_prefixes}'
            - queue_all_runs: '${queue_all_runs}'
            - speculative_enabled: '${speculative_enabled}'
            - ingress_submodules: '${ingress_submodules}'
            - vcs_repo_id: '${vcs_repo_id}'
            - vcs_branch_name: '${vcs_branch_name}'
            - oauth_token_id: '${oauth_token_id}'
            - terraform_version: '${terraform_version}'
            - request_body: null
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - workspace_id
        navigate:
          - SUCCESS: create_variables
          - FAILURE: on_failure
    - create_variables:
        do:
          io.cloudslang.hashicorp.terraform.variables.create_variables:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - workspace_id: '${workspace_id}'
            - variables_json: '${variables_json}'
            - sensitive_variables_json:
                value: '${sensitive_variables_json}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        navigate:
          - SUCCESS: create_run
          - FAILURE: on_failure
    - create_run:
        do:
          io.cloudslang.hashicorp.terraform.runs.create_run:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - workspace_id: '${workspace_id}'
            - run_message: '${run_message}'
            - is_destroy: '${is_destroy}'
            - request_body: null
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - run_id
        navigate:
          - SUCCESS: is_true
          - FAILURE: on_failure
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${auto_apply}'
        navigate:
          - 'TRUE': wait_for_state_version_id
          - 'FALSE': wait_for_apply_status
    - get_run_status_value:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'data,attributes,status'
        publish:
          - plan_status: '${return_result}'
        navigate:
          - SUCCESS: run_status
          - FAILURE: on_failure
    - run_status:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${plan_status}'
            - second_string: planned
        navigate:
          - SUCCESS: apply_run
          - FAILURE: on_failure
    - apply_run:
        do:
          io.cloudslang.hashicorp.terraform.runs.apply_run:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - run_id: '${run_id}'
            - run_comment: '${run_comment}'
            - request_body: null
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish: []
        navigate:
          - SUCCESS: wait_for_state_version_id
          - FAILURE: on_failure
    - wait_for_apply_status:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '240'
        navigate:
          - SUCCESS: get_run_details
          - FAILURE: on_failure
    - get_current_state_version:
        do:
          io.cloudslang.hashicorp.terraform.stateversions.get_current_state_version:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - workspace_id: '${workspace_id}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - hosted_state_download_url
          - state_version_id
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - wait_for_state_version_id:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '180'
        navigate:
          - SUCCESS: get_current_state_version
          - FAILURE: on_failure
    - get_run_details:
        do:
          io.cloudslang.hashicorp.terraform.runs.get_run_details:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - run_id: '${run_id}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - return_result
        navigate:
          - SUCCESS: get_run_status_value
          - FAILURE: on_failure
  outputs:
    - hosted_state_url: '${hosted_state_download_url}'
    - state_version_id: '${state_version_id}'
  results:
    - FAILURE
    - SUCCESS

namespace: io.cloudslang.hashicorp.terraform.automation_content.utils
flow:
  name: tf_plan_apply
  inputs:
    - tf_user_auth_token:
        sensitive: true
    - tf_instance_organization_name
    - tf_template_workspace_name
    - tf_instance_workspace_id
    - is_destroy:
        required: false
    - auto_apply:
        required: false
    - workspace_description:
        required: false
    - working_directory:
        required: false
    - workspace_variable_category:
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
    - tf_run_message:
        required: false
    - tf_run_comment:
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
    - connect_timeout:
        required: false
    - keep_alive:
        required: false
    - connections_max_per_route:
        required: false
    - connections_max_total:
        required: false
    - response_character_set:
        required: false
  workflow:
    - create_run_v3:
        do:
          io.cloudslang.hashicorp.terraform.runs.create_run_v3:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - workspace_id:
                value: '${tf_instance_workspace_id}'
                sensitive: true
            - tf_run_message: '${tf_run_message}'
            - is_destroy: '${is_destroy}'
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
        publish:
          - tf_run_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_auto_apply_true
    - is_auto_apply_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${auto_apply}'
        navigate:
          - 'TRUE': get_run_details_for_get_state_version_details
          - 'FALSE': get_run_details_v2
    - get_run_details_v2:
        do:
          io.cloudslang.hashicorp.terraform.runs.get_run_details_v2:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - tf_run_id: '${tf_run_id}'
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
          - SUCCESS: apply_run_v3
          - FAILURE: counter_for_run_status
    - counter_for_run_status:
        do:
          io.cloudslang.hashicorp.terraform.utils.counter:
            - from: '1'
            - to: '100'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_for_plan_status
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_plan_status:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_run_details_v2
          - FAILURE: on_failure
    - get_current_state_version:
        do:
          io.cloudslang.hashicorp.terraform.stateversions.get_current_state_version:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - workspace_id: '${tf_instance_workspace_id}'
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
    - get_run_details_for_get_state_version_details:
        do:
          io.cloudslang.hashicorp.terraform.runs.get_run_details_v2:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - tf_run_id: '${tf_run_id}'
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
          - SUCCESS: get_run_status_value_state_version
          - FAILURE: on_failure
    - get_run_status_value_state_version:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'data,attributes,status'
        publish:
          - plan_status: '${return_result}'
        navigate:
          - SUCCESS: run_status_for_get_state_version_details
          - FAILURE: on_failure
    - run_status_for_get_state_version_details:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${plan_status}'
            - second_string: applied
        navigate:
          - SUCCESS: get_current_state_version
          - FAILURE: counter_for_get_state_version_details
    - counter_for_get_state_version_details:
        do:
          io.cloudslang.hashicorp.terraform.utils.counter:
            - from: '1'
            - to: '100'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_for_get_state_version_details
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_get_state_version_details:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_run_details_for_get_state_version_details
          - FAILURE: on_failure
    - apply_run_v3:
        do:
          io.cloudslang.hashicorp.terraform.runs.apply_run_v3:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - tf_run_id:
                value: '${tf_run_id}'
                sensitive: true
            - tf_run_message: '${tf_run_message}'
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
        navigate:
          - SUCCESS: get_run_details_for_get_state_version_details
          - FAILURE: on_failure
  outputs:
    - hosted_state_download_url: '${hosted_state_download_url}'
    - state_version_id: '${state_version_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_run_status_value:
        x: 240
        'y': 280
      apply_run_v3:
        x: 400
        'y': 280
      wait_for_get_state_version_details:
        x: 600
        'y': 280
      run_status:
        x: 440
        'y': 440
      wait_for_plan_status:
        x: 80
        'y': 480
      counter_for_get_state_version_details:
        x: 600
        'y': 480
        navigate:
          44a91456-5dde-6693-18b3-6a90f785ac5c:
            targetId: fabb57bb-b303-6dcd-b4cf-e667fa2870cd
            port: NO_MORE
      get_run_status_value_state_version:
        x: 560
        'y': 120
      get_run_details_for_get_state_version_details:
        x: 400
        'y': 120
      create_run_v3:
        x: 80
        'y': 120
      run_status_for_get_state_version_details:
        x: 760
        'y': 280
      get_run_details_v2:
        x: 80
        'y': 280
      is_auto_apply_true:
        x: 240
        'y': 120
      get_current_state_version:
        x: 880
        'y': 280
        navigate:
          7a5d402b-8582-098f-e314-545a43a70854:
            targetId: 314e7f88-a400-c545-369a-d99c5cb2767c
            port: SUCCESS
      counter_for_run_status:
        x: 240
        'y': 480
        navigate:
          efd7be8d-6f09-a3ee-7405-de433178e78d:
            targetId: fabb57bb-b303-6dcd-b4cf-e667fa2870cd
            port: NO_MORE
    results:
      FAILURE:
        fabb57bb-b303-6dcd-b4cf-e667fa2870cd:
          x: 400
          'y': 600
      SUCCESS:
        314e7f88-a400-c545-369a-d99c5cb2767c:
          x: 1040
          'y': 280

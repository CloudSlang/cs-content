namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
flow:
  name: get_sensitive_input_var_value
  inputs:
    - tf_template_workspace_id
    - tf_user_auth_token
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - worker_group:
        default: RAS_Operator_Path
        required: false
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
    - list_runs_in_template_workspace:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://app.terraform.io/api/v2/workspaces/'+tf_template_workspace_id+'/runs'}"
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
            - headers: "${'content-type: application/vnd.api+json\\n'+'Authorization:Bearer '+tf_user_auth_token}"
            - worker_group: '${worker_group}'
        publish:
          - run_list: '${return_result}'
        navigate:
          - SUCCESS: get_run_id_and_plan_id_python
          - FAILURE: on_failure
    - show_plan_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://app.terraform.io/api/v2/plans/'+tf_plan_id+'/json-output'}"
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
            - headers: "${'content-type: application/vnd.api+json\\n'+'Authorization:Bearer '+tf_user_auth_token}"
            - worker_group: '${worker_group}'
        publish:
          - plan_details: '${return_result}'
        navigate:
          - SUCCESS: get_all_input_variable
          - FAILURE: on_failure
    - get_all_input_variable:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${plan_details}'
            - json_path: variables
        publish:
          - input_results: '${return_result}'
        navigate:
          - SUCCESS: get_input_keyname_python
          - FAILURE: on_failure
    - get_run_id_and_plan_id_python:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.get_run_id_and_plan_id_python:
            - run_list: '${run_list}'
        publish:
          - tf_run_id: '${tf_run_id}'
          - tf_plan_id: '${tf_plan_id}'
        navigate:
          - SUCCESS: show_plan_details
    - get_input_keyname_python:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.get_input_keyname_python:
            - input_results: '${input_results}'
        publish:
          - input_keyname_keyvalue_list: '${result}'
          - input_results_keyname: '${input_results_keyname_list}'
          - input_results_keyvalue_list: '${input_results_keyvalue_list}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - input_results_keyname
    - input_results_keyvalue_list
    - input_keyname_keyvalue_list
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      list_runs_in_template_workspace:
        x: 120
        'y': 120
      show_plan_details:
        x: 440
        'y': 120
      get_all_input_variable:
        x: 560
        'y': 120
      get_run_id_and_plan_id_python:
        x: 280
        'y': 120
      get_input_keyname_python:
        x: 680
        'y': 120
        navigate:
          6acd93b8-9229-0a7c-3a84-cf9ac0ded55d:
            targetId: fb1b6ee0-e090-bf53-a6b8-3ce4a61afe14
            port: SUCCESS
    results:
      SUCCESS:
        fb1b6ee0-e090-bf53-a6b8-3ce4a61afe14:
          x: 800
          'y': 120

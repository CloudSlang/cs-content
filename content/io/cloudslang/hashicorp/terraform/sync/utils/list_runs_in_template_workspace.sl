namespace: io.cloudslang.hashicorp.terraform.sync.utils
flow:
  name: list_runs_in_template_workspace
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
  workflow:
    - list_runs_in_template_workspace:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://app.terraform.io/api/v2/workspaces/'+tf_template_workspace_id+'/runs'}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - headers: "${'content-type: application/vnd.api+json\\n'+'Authorization:Bearer '+tf_user_auth_token}"
        publish:
          - run_list: '${return_result}'
        navigate:
          - SUCCESS: get_run_id_and_plan_id_python
          - FAILURE: on_failure
    - show_plan_details:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://app.terraform.io/api/v2/plans/'+tf_plan_id+'/json-output'}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - headers: "${'content-type: application/vnd.api+json\\n'+'Authorization:Bearer '+tf_user_auth_token}"
        publish:
          - plan_details: '${return_result}'
        navigate:
          - SUCCESS: get_tf_output_variable
          - FAILURE: on_failure
    - get_tf_output_variable:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${plan_details}'
            - json_path: 'planned_values,outputs'
        publish:
          - output_variable_list: '${return_result}'
        navigate:
          - SUCCESS: get_output_variable_python
          - FAILURE: on_failure
    - get_run_id_and_plan_id_python:
        do:
          HashiCorp.Terraform.python_operations.get_run_id_and_plan_id_python:
            - run_list: '${run_list}'
        publish:
          - tf_run_id: '${tf_run_id}'
          - tf_plan_id: '${tf_plan_id}'
        navigate:
          - SUCCESS: show_plan_details
    - get_output_variable_python:
        do:
          HashiCorp.Terraform.python_operations.get_output_variable_python:
            - output_variable_list: '${output_variable_list}'
        publish:
          - output_variable_key_list: '${output_variable_key_list}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - output_variable_key_list: '${output_variable_key_list}'
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
      get_tf_output_variable:
        x: 560
        'y': 120
      get_run_id_and_plan_id_python:
        x: 280
        'y': 120
      get_output_variable_python:
        x: 680
        'y': 120
        navigate:
          f42f973e-8947-b0e3-5760-7ff3afe3f8de:
            targetId: fb1b6ee0-e090-bf53-a6b8-3ce4a61afe14
            port: SUCCESS
    results:
      SUCCESS:
        fb1b6ee0-e090-bf53-a6b8-3ce4a61afe14:
          x: 800
          'y': 120

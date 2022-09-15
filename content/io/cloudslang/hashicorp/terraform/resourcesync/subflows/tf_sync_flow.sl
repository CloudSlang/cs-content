namespace: io.cloudslang.hashicorp.terraform.resourcesync.subflows
flow:
  name: tf_sync_flow
  inputs:
    - host
    - tenant_id
    - dnd_username
    - dnd_password:
        sensitive: true
    - tf_user_auth_token:
        sensitive: true
    - tf_template_organization_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - component_id: bb9cb58417414d618ece96e43911dba2
    - worker_group:
        required: false
  workflow:
    - create_dnd_auth_token:
        do:
          io.cloudslang.microfocus.content.create_dnd_auth_token:
            - dnd_host: '${host}'
            - dnd_username: '${dnd_username}'
            - dnd_password:
                value: '${dnd_password}'
                sensitive: true
            - tenant_id: '${tenant_id}'
        publish:
          - dnd_auth_token
        navigate:
          - SUCCESS: list_workspaces
          - FAILURE: on_failure
    - get_tf_variables:
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.get_tf_variables:
            - tf_user_auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - tf_template_organization_name: '${tf_template_organization_name}'
            - tf_template_workspace_name: '${workspace_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
        publish:
          - tf_variables_list: '${tf_variables_list}'
          - tf_template_workspace_id
          - tf_template_vcs_repo_identifier
          - tf_output_variable_key_list: '${output_variable_key_list}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_component_template
    - list_workspaces:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.list_workspaces:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - organization_name: '${tf_template_organization_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - workspace_list
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${workspace_list}'
        publish:
          - workspace_name: '${result_string}'
        navigate:
          - HAS_MORE: get_tf_variables
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - create_component_template:
        do:
          io.cloudslang.microfocus.content.create_component_template:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - component_id: '${component_id}'
            - template_name: '${workspace_name}'
        publish:
          - component_template_id
        navigate:
          - SUCCESS: create_component_template_property
          - FAILURE: on_failure
    - create_component_template_property:
        do:
          io.cloudslang.microfocus.content.create_component_template_property:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - template_id: '${component_template_id}'
            - property_name: tf_template_workspace_id
            - property_value: '${tf_template_workspace_id}'
        navigate:
          - SUCCESS: create_component_template_property_1
          - FAILURE: on_failure
    - create_component_template_property_1:
        do:
          io.cloudslang.microfocus.content.create_component_template_property:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - template_id: '${component_template_id}'
            - property_name: tf_instance_workspace_id
            - property_value: default
        navigate:
          - SUCCESS: create_tf_input_variables_in_component_template
          - FAILURE: on_failure
    - create_tf_input_variables_in_component_template:
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.create_tf_input_variables_in_component_template:
            - tf_variables_list: '${tf_variables_list}'
            - component_template_id: '${component_template_id}'
            - host: '${host}'
            - tenant_id: '${tenant_id}'
            - x_auth_token: '${dnd_auth_token}'
            - tf_template_workspace_id: '${tf_template_workspace_id}'
            - tf_user_auth_token: '${tf_user_auth_token}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_tf_output_variables_in_component_template
    - create_tf_output_variables_in_component_template:
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.create_tf_output_variables_in_component_template:
            - tf_output_variable_key_list: '${tf_output_variable_key_list}'
            - component_template_id: '${component_template_id}'
            - host: '${host}'
            - tenant_id: '${tenant_id}'
            - x_auth_token: '${dnd_auth_token}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - tf_template_vcs_repo_identifier: '${tf_template_vcs_repo_identifier}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_all_resource_offering_details
    - associate_ro_in_template:
        do:
          io.cloudslang.microfocus.content.associate_ro_in_template:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - template_id: '${component_template_id}'
            - resource_offering_id: '${ro_id}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - list_all_resource_offering_details:
        do:
          io.cloudslang.microfocus.content.list_all_resource_offering_details:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - x_auth_token: '${dnd_auth_token}'
        publish:
          - return_result
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_ro_id_python
    - get_ro_id_python:
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.get_ro_id_python:
            - ro_list: '${return_result}'
        publish:
          - ro_id: '${ro_id.split("/resource/offering/")[1]}'
        navigate:
          - SUCCESS: associate_ro_in_template
  outputs:
    - component_template_id: '${component_template_id}'
    - tf_source_vcs_repo_identifier: '${tf_source_vcs_repo_identifier}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_component_template_property_1:
        x: 560
        'y': 120
      get_ro_id_python:
        x: 880
        'y': 360
      create_dnd_auth_token:
        x: 80
        'y': 360
      create_tf_input_variables_in_component_template:
        x: 720
        'y': 120
      list_iterator:
        x: 400
        'y': 360
        navigate:
          740a6733-01ad-81c1-ba86-6b4c416a1acf:
            targetId: b79ac630-86cf-5ab0-94c1-93de1aa81b22
            port: NO_MORE
      get_tf_variables:
        x: 80
        'y': 120
      associate_ro_in_template:
        x: 720
        'y': 360
      create_component_template_property:
        x: 400
        'y': 120
      create_tf_output_variables_in_component_template:
        x: 880
        'y': 120
      list_all_resource_offering_details:
        x: 1040
        'y': 120
      list_workspaces:
        x: 240
        'y': 360
      create_component_template:
        x: 240
        'y': 120
    results:
      SUCCESS:
        b79ac630-86cf-5ab0-94c1-93de1aa81b22:
          x: 400
          'y': 560

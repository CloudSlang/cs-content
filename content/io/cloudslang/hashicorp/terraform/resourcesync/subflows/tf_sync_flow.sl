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
    - component_id: bb9cb58417414d618ece96e43911dba2
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
    - create_dnd_auth_token:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
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
          - SUCCESS: list_all_resource_offering_details
          - FAILURE: on_failure
    - get_tf_variables:
        worker_group:
          value: '${worker_group}'
          override: true
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
            - worker_group: '${worker_group}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - tf_variables_list: '${tf_variables_list}'
          - tf_template_workspace_id
          - tf_template_vcs_repo_identifier
          - tf_output_variable_key_list: '${output_variable_key_list}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_component_template
    - list_workspaces:
        worker_group: '${worker_group}'
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
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - workspace_list
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - list_iterator:
        worker_group: '${worker_group}'
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
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.create_component_template:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - component_id: '${component_id}'
            - template_name: '${workspace_name}'
            - template_icon: terraform.png?tag=library
        publish:
          - component_template_id
        navigate:
          - SUCCESS: create_component_template_property_template_workspace_is
          - FAILURE: on_failure
    - create_component_template_property_template_workspace_is:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
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
          - SUCCESS: create_component_template_property_instance_workspace_is
          - FAILURE: on_failure
    - create_component_template_property_instance_workspace_is:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.create_component_template_property:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - template_id: '${component_template_id}'
            - property_name: tf_instance_workspace_id
        navigate:
          - SUCCESS: create_tf_input_variables_in_component_template
          - FAILURE: on_failure
    - create_tf_input_variables_in_component_template:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.create_tf_input_variables_in_component_template:
            - tf_variables_list: '${tf_variables_list}'
            - component_template_id: '${component_template_id}'
            - host: '${host}'
            - tenant_id: '${tenant_id}'
            - x_auth_token: '${dnd_auth_token}'
            - tf_template_workspace_id: '${tf_template_workspace_id}'
            - tf_user_auth_token: '${tf_user_auth_token}'
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_tf_output_variables_in_component_template
    - create_tf_output_variables_in_component_template:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.create_tf_output_variables_in_component_template:
            - tf_output_variable_key_list: '${tf_output_variable_key_list}'
            - component_template_id: '${component_template_id}'
            - host: '${host}'
            - tenant_id: '${tenant_id}'
            - x_auth_token: '${dnd_auth_token}'
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - tf_template_vcs_repo_identifier: '${tf_template_vcs_repo_identifier}'
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: associate_ro_in_template
    - associate_ro_in_template:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
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
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
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
          - SUCCESS: get_ro_id
    - get_ro_id:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.get_ro_id_python:
            - ro_list: '${return_result}'
        publish:
          - ro_id: '${ro_id.split("/resource/offering/")[1]}'
        navigate:
          - SUCCESS: list_workspaces
  outputs:
    - component_template_id: '${component_template_id}'
    - tf_source_vcs_repo_identifier: '${tf_source_vcs_repo_identifier}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_dnd_auth_token:
        x: 80
        'y': 120
      create_component_template_property_template_workspace_is:
        x: 400
        'y': 480
      create_tf_input_variables_in_component_template:
        x: 720
        'y': 480
      list_iterator:
        x: 720
        'y': 120
        navigate:
          740a6733-01ad-81c1-ba86-6b4c416a1acf:
            targetId: b79ac630-86cf-5ab0-94c1-93de1aa81b22
            port: NO_MORE
      get_tf_variables:
        x: 80
        'y': 480
      associate_ro_in_template:
        x: 880
        'y': 280
      create_component_template_property_instance_workspace_is:
        x: 560
        'y': 480
      get_ro_id:
        x: 400
        'y': 120
      create_tf_output_variables_in_component_template:
        x: 880
        'y': 480
      list_all_resource_offering_details:
        x: 240
        'y': 120
      list_workspaces:
        x: 560
        'y': 120
      create_component_template:
        x: 240
        'y': 480
    results:
      SUCCESS:
        b79ac630-86cf-5ab0-94c1-93de1aa81b22:
          x: 880
          'y': 120

namespace: io.cloudslang.hashicorp.terraform.automation_content
flow:
  name: terraform_deploy
  inputs:
    - tf_user_auth_token:
        sensitive: true
    - tf_template_organization_name
    - tf_instance_organization_name:
        required: true
    - tf_instance_workspace_name_prefix: HCMX_
    - service_component_id
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
    - get_dnd_credentials:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.base.utils.do_nothing:
            - dnd_username: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
        publish:
          - tenant_id: '${dnd_username.split("/")[0]}'
          - dnd_username: '${dnd_username.split("/")[1]}'
        navigate:
          - SUCCESS: get_host
          - FAILURE: on_failure
    - list_instance_org_oauth_client:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.utils.list_o_auth_client:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - organization_name: '${tf_instance_organization_name}'
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
          - oauth_token_id
        navigate:
          - SUCCESS: set_workspace_name
          - FAILURE: on_failure
    - set_workspace_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - input_0: "${tf_instance_workspace_name_prefix+tf_template_workspace_name+'-'+service_component_id}"
        publish:
          - tf_instance_workspace_name: '${input_0}'
        navigate:
          - SUCCESS: create_workspace_v2
          - FAILURE: on_failure
    - get_host:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.base.utils.do_nothing:
            - host: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_uri')}"
        publish:
          - host: '${host.split("//")[1].replace(":443/dnd/rest", "")}'
        navigate:
          - SUCCESS: create_dnd_auth_token
          - FAILURE: on_failure
    - get_workspace_details:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.workspaces.get_workspace_details:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - organization_name: '${tf_template_organization_name}'
            - workspace_name: '${tf_template_workspace_name}'
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
          - tf_template_workspace_id: '${workspace_id}'
          - workspace_info: '${return_result}'
        navigate:
          - SUCCESS: get_template_vcs_repo_identifier
          - FAILURE: on_failure
    - get_template_vcs_repo_identifier:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${workspace_info}'
            - json_path: 'data,attributes,vcs-repo-identifier'
        publish:
          - tf_template_vcs_repo_identifier: '${return_result}'
        navigate:
          - SUCCESS: list_instance_org_oauth_client
          - FAILURE: on_failure
    - tf_plan_apply:
        do:
          io.cloudslang.hashicorp.terraform.automation_content.utils.tf_plan_apply:
            - tf_user_auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - tf_instance_organization_name: '${tf_instance_organization_name}'
            - tf_template_workspace_name: '${tf_template_workspace_name}'
            - tf_instance_workspace_id: '${tf_instance_workspace_id}'
            - auto_apply: 'true'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
        publish:
          - state_version_id
          - hosted_state_download_url
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_or_update_service_component_property
    - get_component_template_details_and_create_workspace_variables:
        do:
          io.cloudslang.hashicorp.terraform.automation_content.utils.get_component_template_details_and_create_workspace_variables:
            - component_template_id: '${service_component_id}'
            - proxy_host: '${proxy_host}'
            - tf_instance_workspace_id: '${tf_instance_workspace_id}'
            - proxy_port: '${proxy_port}'
            - tf_user_auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - dnd_username: '${dnd_username}'
            - user_identifier: '${user_identifier}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
        publish:
          - property_value_list
        navigate:
          - FAILURE: on_failure
          - SUCCESS: tf_plan_apply
    - list_output_variables:
        do:
          io.cloudslang.hashicorp.terraform.automation_content.utils.list_output_variables:
            - property_value_list: '${property_value_list}'
            - state_version_id: '${state_version_id}'
            - hosted_state_download_url: '${hosted_state_download_url}'
            - service_component_id: '${service_component_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - user_identifier: '${user_identifier}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_user_identifier:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.get_user_identifier: []
        publish:
          - user_identifier: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_artifact_properties
    - create_dnd_auth_token:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.create_dnd_auth_token:
            - dnd_host: '${host}'
            - dnd_username: '${dnd_username}'
            - tenant_id: '${tenant_id}'
        publish:
          - dnd_auth_token
        navigate:
          - SUCCESS: get_user_identifier
          - FAILURE: on_failure
    - get_artifact_properties:
        do:
          io.cloudslang.microfocus.content.get_artifact_properties:
            - user_identifier: '${user_identifier}'
            - artifact_id: '${service_component_id}'
        publish:
          - tf_template_workspace_name: '${property_value_list.split(";")[1]}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_workspace_details
    - create_workspace_v2:
        do:
          io.cloudslang.microfocus.create_workspace_v2:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - organization_name: '${tf_instance_organization_name}'
            - workspace_name: '${tf_instance_workspace_name}'
            - auto_apply: 'true'
            - vcs_repo_id: '${tf_template_vcs_repo_identifier}'
            - oauth_token_id: '${oauth_token_id}'
            - worker_group: '${worker_group}'
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
          - tf_instance_workspace_id: '${workspace_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_component_template_details_and_create_workspace_variables
    - add_or_update_service_component_property:
        do:
          io.cloudslang.microfocus.content.add_or_update_service_component_property:
            - component_id: '${service_component_id}'
            - user_identifier: '${user_identifier}'
            - property_name: tf_instance_workspace_id
            - property_values: '${tf_instance_workspace_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_output_variables
  outputs:
    - tf_instance_workspace_name
    - tf_instance_workspace_id
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_template_vcs_repo_identifier:
        x: 520
        'y': 80
        navigate:
          878e52c6-b659-2e79-32d2-b266b5342411:
            vertices: []
            targetId: list_instance_org_oauth_client
            port: SUCCESS
      tf_plan_apply:
        x: 840
        'y': 280
      get_component_template_details_and_create_workspace_variables:
        x: 840
        'y': 80
      create_workspace_v2:
        x: 680
        'y': 280
      create_dnd_auth_token:
        x: 200
        'y': 80
      get_dnd_credentials:
        x: 40
        'y': 80
      get_workspace_details:
        x: 360
        'y': 280
      get_host:
        x: 40
        'y': 280
      set_workspace_name:
        x: 680
        'y': 80
      get_user_identifier:
        x: 200
        'y': 280
      list_instance_org_oauth_client:
        x: 520
        'y': 280
      get_artifact_properties:
        x: 360
        'y': 80
      add_or_update_service_component_property:
        x: 1000
        'y': 80
      list_output_variables:
        x: 1000
        'y': 280
        navigate:
          9559ad00-5e84-fdcd-7f88-f7c7f9688410:
            targetId: 8a94a410-8ddd-3c39-6651-daa852ea17f7
            port: SUCCESS
    results:
      SUCCESS:
        8a94a410-8ddd-3c39-6651-daa852ea17f7:
          x: 1200
          'y': 280

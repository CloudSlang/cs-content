namespace: io.cloudslang.hashicorp.terraform.resourcesync
flow:
  name: terraform_organization_resource_sync
  inputs:
    - CSA_CONTEXT_ID:
        required: false
    - CSA_PROCESS_ID:
        required: false
    - provider_id:
        required: false
  workflow:
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
          - SUCCESS: is_null
    - is_null:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${provider_id}'
        publish: []
        navigate:
          - IS_NULL: get_resource_pool_details
          - IS_NOT_NULL: get_resource_provider_access_details
    - get_resource_pool_details:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.get_resource_pool_details:
            - user_identifier: '${user_identifier}'
            - resource_pool_id: '${CSA_CONTEXT_ID}'
            - resource_type: 'NULL'
        publish:
          - provider_id: '${resource_provider_id}'
          - pool_reference: '${resource_pool_reference}'
        navigate:
          - FAILURE: do_nothing
          - SUCCESS: get_resource_provider_access_details
    - get_resource_provider_access_details:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.get_resource_provider_access_details:
            - user_identifier: '${user_identifier}'
            - provider_id: '${provider_id}'
        publish:
          - host: '${hostname}'
          - username: '${provider_username}'
          - password: '${provider_password}'
          - port
          - protocol
          - provider_sap
        navigate:
          - FAILURE: do_nothing
          - SUCCESS: get_artifact_properties
    - do_nothing:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.base.utils.do_nothing:
            - process_status: Unable to retrieve artifact properties
        publish:
          - process_status
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - get_artifact_properties:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.get_artifact_properties:
            - user_identifier: '${user_identifier}'
            - artifact_id: '${provider_id}'
            - property_names: 'proxyHost|proxyPort|proxyUsername|proxyPassword|excludedRegions|workerGroup|tf_user_auth_token|tf_template_organization_name'
        publish:
          - property_value_string: '${property_value_list}'
          - proxy_host: '${property_value_list.split("|")[0].split(";")[1]}'
          - proxy_port: '${property_value_list.split("|")[1].split(";")[1]}'
          - proxy_username: '${property_value_list.split("|")[2].split(";")[1]}'
          - proxy_password: '${property_value_list.split("|")[3].split(";")[1]}'
          - tf_user_auth_token: '${property_value_list.split("|")[5].split(";")[1]}'
          - worker_group: '${property_value_list.split("|")[4]}'
          - tf_template_organization_name: '${property_value_list.split("|")[6]}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: string_equals
    - string_equals:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${worker_group}'
            - second_string: workerGroup;
        navigate:
          - SUCCESS: set_default_worker_group
          - FAILURE: set_default_worker_group_1
    - set_default_worker_group:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.base.utils.do_nothing:
            - worker_group: RAS_Operator_Path
        publish:
          - worker_group
        navigate:
          - SUCCESS: get_dnd_credentials
          - FAILURE: on_failure
    - set_default_worker_group_1:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.base.utils.do_nothing:
            - worker_group: '${worker_group.split(";")[1]}'
        publish:
          - worker_group
        navigate:
          - SUCCESS: get_dnd_credentials
          - FAILURE: on_failure
    - get_dnd_credentials:
        do:
          io.cloudslang.base.utils.do_nothing:
            - dnd_username: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
        publish:
          - tenant_id: '${dnd_username.split("/")[0]}'
          - dnd_username: '${dnd_username.split("/")[1]}'
        navigate:
          - SUCCESS: get_host
          - FAILURE: on_failure
    - get_host:
        do:
          io.cloudslang.base.utils.do_nothing:
            - host: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_uri')}"
        publish:
          - host: '${host.split("//")[1].replace(":443/dnd/rest", "")}'
        navigate:
          - SUCCESS: tf_sync_flow
          - FAILURE: on_failure
    - tf_sync_flow:
        do:
          io.cloudslang.hashicorp.terraform.sync.utils.tf_sync_flow:
            - host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_username: '${dnd_username}'
            - dnd_password:
                value: '${password}'
                sensitive: true
            - tf_user_auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - tf_template_organization_name: '${tf_template_organization_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      tf_sync_flow:
        x: 1120
        'y': 200
        navigate:
          400eaf7b-bdde-1706-8308-9659cf090013:
            targetId: cf89e216-bfb2-9e1d-e1c7-7d138205c7cf
            port: SUCCESS
      get_resource_pool_details:
        x: 240
        'y': 200
      set_default_worker_group_1:
        x: 960
        'y': 40
      get_resource_provider_access_details:
        x: 400
        'y': 40
      string_equals:
        x: 760
        'y': 40
      get_dnd_credentials:
        x: 960
        'y': 200
      get_host:
        x: 1120
        'y': 40
      get_user_identifier:
        x: 80
        'y': 40
      get_artifact_properties:
        x: 560
        'y': 40
      do_nothing:
        x: 400
        'y': 200
        navigate:
          d4a680ea-612c-8f10-e602-1d667635d56a:
            targetId: e322cc43-d07a-b464-08d9-a49b3b393c0d
            port: SUCCESS
      set_default_worker_group:
        x: 760
        'y': 200
      is_null:
        x: 240
        'y': 40
    results:
      FAILURE:
        e322cc43-d07a-b464-08d9-a49b3b393c0d:
          x: 560
          'y': 200
      SUCCESS:
        cf89e216-bfb2-9e1d-e1c7-7d138205c7cf:
          x: 920
          'y': 400

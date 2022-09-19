namespace: io.cloudslang.hashicorp.terraform.resourcesync.subflows
flow:
  name: create_tf_input_variables_in_component_template
  inputs:
    - tf_variables_list
    - component_template_id
    - host
    - tenant_id
    - x_auth_token
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
  workflow:
    - input_variable_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.input_variable_list:
            - data: '${tf_variables_list}'
        publish:
          - return_result
        navigate:
          - SUCCESS: list_iterator
    - create_component_template_property:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://'+host+'/dnd/api/v1/'+tenant_id+'/property'}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: "${'content-type: application/json\\n'+'Accept: application/json\\n'+'X-Auth-Token:'+x_auth_token}"
            - body: "${'{\"global_id\":\"\",\"@type\":\"\",\"name\": \"tf_input_'+key_name+'\",\"description\":null,\"property_type\":\"STRING\",\"property_value\":\"'+key_value+'\",\"ownership\": null,\"owner\":{\"global_id\":\"'+component_template_id+'\"},\"upgradeLocked\":false,\"bindings\":[],\"ext\":{\"csa_critical_system_object\":false,\"csa_name_key\":\"tf_input_'+key_name+'\",\"csa_consumer_visible\":false,\"csa_confidential\":'+csa_confidential+'},\"visibleWhenDeployDesign\":true,\"requiredWhenDeployDesign\": false}'}"
            - content_type: application/json
        publish:
          - output_0: '${error_message}'
          - output_1: '${response_headers}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - check_property_key_is_sensitive:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${is_sensitive}'
            - second_string: 'True'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_csa_confidential_value_true
          - FAILURE: set_csa_confidential_value_false
    - get_sensitive_input:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.get_sensitive_input_var_value:
            - tf_template_workspace_id: '${tf_template_workspace_id}'
            - tf_user_auth_token: '${tf_user_auth_token}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
        publish:
          - input_results_keyname
          - input_keyname_keyvalue_list
        navigate:
          - SUCCESS: get_sensitive_value
          - FAILURE: on_failure
    - set_csa_confidential_value_true:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - csa_confidential: 'true'
        publish:
          - csa_confidential
        navigate:
          - SUCCESS: get_sensitive_input
          - FAILURE: on_failure
    - set_csa_confidential_value_false:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - csa_confidential: 'false'
        publish:
          - csa_confidential
        navigate:
          - SUCCESS: create_component_template_property
          - FAILURE: on_failure
    - get_sensitive_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.get_sensitive_value_python:
            - input_results_keyname: '${input_results_keyname}'
            - input_keyname_keyvalue_list: '${input_keyname_keyvalue_list}'
            - original_keyname: '${key_name}'
        publish:
          - key_value: '${retrieved_keyvalue}'
        navigate:
          - SUCCESS: create_component_template_property
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${return_result}'
        publish:
          - result_string
        navigate:
          - HAS_MORE: get_property_key_and_value
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - check_key_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${key_value}'
            - second_string: empty
        navigate:
          - SUCCESS: set_key_value_empty
          - FAILURE: check_property_key_is_sensitive
    - set_key_value_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - key_value: ''
        publish:
          - key_value
        navigate:
          - SUCCESS: check_property_key_is_sensitive
          - FAILURE: on_failure
    - get_property_key_and_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - key_name: '${result_string.split(":::")[0]}'
            - key_value: '${result_string.split(":::")[1]}'
            - is_sensitive: '${result_string.split(":::")[2]}'
        publish:
          - key_name
          - key_value
          - is_sensitive
        navigate:
          - SUCCESS: check_key_value
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_key_value_empty:
        x: 40
        'y': 440
      set_csa_confidential_value_true:
        x: 200
        'y': 400
      get_property_key_and_value:
        x: 160
        'y': 160
      set_csa_confidential_value_false:
        x: 360
        'y': 240
      input_variable_list:
        x: 40
        'y': 80
      list_iterator:
        x: 320
        'y': 80
        navigate:
          83ddc624-d1ca-5e2e-ed87-27bde196c653:
            targetId: c24137a6-111f-83a4-cb98-ee4ece4c1920
            port: NO_MORE
      check_property_key_is_sensitive:
        x: 200
        'y': 240
      create_component_template_property:
        x: 520
        'y': 240
      get_sensitive_input:
        x: 360
        'y': 400
      check_key_value:
        x: 40
        'y': 240
      get_sensitive_value:
        x: 520
        'y': 400
    results:
      SUCCESS:
        c24137a6-111f-83a4-cb98-ee4ece4c1920:
          x: 520
          'y': 80

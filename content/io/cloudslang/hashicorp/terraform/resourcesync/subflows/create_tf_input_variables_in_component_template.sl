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
  workflow:
    - array_iterator:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${tf_variables_list}'
        publish:
          - output_0: '${result_string}'
        navigate:
          - HAS_MORE: get_keyname
          - NO_MORE: get_keyname_1
          - FAILURE: on_failure
    - get_keyname:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${output_0}'
            - json_path: 'attributes,key'
        publish:
          - key_name: "${'tf_input_'+return_result}"
          - original_keyname: '${return_result}'
        navigate:
          - SUCCESS: get_keyvalue
          - FAILURE: on_failure
    - get_keyvalue:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${output_0}'
            - json_path: 'attributes,value'
        publish:
          - key_value: '${return_result}'
        navigate:
          - SUCCESS: get_sensitive_value
          - FAILURE: on_failure
    - get_keyname_1:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${output_0}'
            - json_path: 'attributes,key'
        publish:
          - key_name: "${'tf_input_'+return_result}"
          - original_keyname: '${return_result}'
        navigate:
          - SUCCESS: get_keyvalue_1
          - FAILURE: on_failure
    - get_keyvalue_1:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${output_0}'
            - json_path: 'attributes,value'
        publish:
          - key_value: '${return_result}'
        navigate:
          - SUCCESS: get_sensitive_value_1
          - FAILURE: on_failure
    - create_component_template_property:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://'+host+'/dnd/api/v1/'+tenant_id+'/property'}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: "${'content-type: application/json\\n'+'Accept: application/json\\n'+'X-Auth-Token:'+x_auth_token}"
            - body: "${'{\"global_id\":\"\",\"@type\":\"\",\"name\": \"'+key_name+'\",\"description\":null,\"property_type\":\"STRING\",\"property_value\":\"'+key_value+'\",\"ownership\": null,\"owner\":{\"global_id\":\"'+component_template_id+'\"},\"upgradeLocked\":false,\"bindings\":[],\"ext\":{\"csa_critical_system_object\":false,\"csa_name_key\":\"'+key_name+'\",\"csa_consumer_visible\":false,\"csa_confidential\":'+csa_confidential+'},\"visibleWhenDeployDesign\":true,\"requiredWhenDeployDesign\": false}'}"
            - content_type: application/json
        publish:
          - output_0: '${error_message}'
          - output_1: '${response_headers}'
        navigate:
          - SUCCESS: array_iterator
          - FAILURE: on_failure
    - create_component_template_property_1:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://'+host+'/dnd/api/v1/'+tenant_id+'/property'}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: "${'content-type: application/json\\n'+'Accept: application/json\\n'+'X-Auth-Token:'+x_auth_token}"
            - body: "${'{\"global_id\":\"\",\"@type\":\"\",\"name\": \"'+key_name+'\",\"description\":null,\"property_type\":\"STRING\",\"property_value\":\"'+key_value+'\",\"ownership\": null,\"owner\":{\"global_id\":\"'+component_template_id+'\"},\"upgradeLocked\":false,\"bindings\":[],\"ext\":{\"csa_critical_system_object\":false,\"csa_name_key\":\"'+key_name+'\",\"csa_consumer_visible\":false,\"csa_confidential\":'+csa_confidential+'},\"visibleWhenDeployDesign\":true,\"requiredWhenDeployDesign\": false}'}"
            - content_type: application/json
        publish:
          - output_0: '${error_message}'
          - output_1: '${response_headers}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_sensitive_value:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${output_0}'
            - json_path: 'attributes,sensitive'
        publish:
          - sensitive_value: '${return_result}'
        navigate:
          - SUCCESS: is_sensitive
          - FAILURE: on_failure
    - get_sensitive_value_1:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${output_0}'
            - json_path: 'attributes,sensitive'
        publish:
          - sensitive_value: '${return_result}'
        navigate:
          - SUCCESS: is_sensitive_1
          - FAILURE: on_failure
    - is_sensitive:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${sensitive_value}'
            - second_string: 'True'
        navigate:
          - SUCCESS: set_csa_confidential_value_true
          - FAILURE: set_csa_confidential_value_false
    - is_sensitive_1:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${sensitive_value}'
            - second_string: 'True'
        navigate:
          - SUCCESS: set_csa_confidential_value_true_1
          - FAILURE: set_csa_confidential_value_false_1
    - get_sensitive_input_var_value:
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
          - SUCCESS: get_sensitive_value_python
          - FAILURE: on_failure
    - get_sensitive_input_var_value_1:
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
          - SUCCESS: get_sensitive_value_python_2
          - FAILURE: on_failure
    - set_csa_confidential_value_true:
        do:
          io.cloudslang.base.utils.do_nothing:
            - csa_confidential: 'true'
        publish:
          - csa_confidential
        navigate:
          - SUCCESS: get_sensitive_input_var_value
          - FAILURE: on_failure
    - set_csa_confidential_value_false:
        do:
          io.cloudslang.base.utils.do_nothing:
            - csa_confidential: 'false'
        publish:
          - csa_confidential
        navigate:
          - SUCCESS: create_component_template_property
          - FAILURE: on_failure
    - set_csa_confidential_value_true_1:
        do:
          io.cloudslang.base.utils.do_nothing:
            - csa_confidential: 'true'
        publish:
          - csa_confidential
        navigate:
          - SUCCESS: get_sensitive_input_var_value_1
          - FAILURE: on_failure
    - set_csa_confidential_value_false_1:
        do:
          io.cloudslang.base.utils.do_nothing:
            - csa_confidential: 'false'
        publish:
          - csa_confidential
        navigate:
          - SUCCESS: create_component_template_property_1
          - FAILURE: on_failure
    - get_sensitive_value_python_2:
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.get_sensitive_value_python:
            - input_results_keyname: '${input_results_keyname}'
            - input_keyname_keyvalue_list: '${input_keyname_keyvalue_list}'
            - original_keyname: '${original_keyname}'
        publish:
          - key_value: '${retrieved_keyvalue}'
        navigate:
          - SUCCESS: create_component_template_property_1
    - get_sensitive_value_python:
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.get_sensitive_value_python:
            - input_results_keyname: '${input_results_keyname}'
            - input_keyname_keyvalue_list: '${input_keyname_keyvalue_list}'
            - original_keyname: '${original_keyname}'
        publish:
          - key_value: '${retrieved_keyvalue}'
        navigate:
          - SUCCESS: create_component_template_property
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_keyname:
        x: 600
        'y': 280
      is_sensitive:
        x: 960
        'y': 280
      get_sensitive_input_var_value_1:
        x: 160
        'y': 360
      create_component_template_property_1:
        x: 320
        'y': 200
        navigate:
          a89ba28f-96bc-698e-cf9d-78ac87668324:
            targetId: c24137a6-111f-83a4-cb98-ee4ece4c1920
            port: SUCCESS
      set_csa_confidential_value_true:
        x: 1080
        'y': 280
      set_csa_confidential_value_false:
        x: 960
        'y': 120
      get_keyvalue_1:
        x: 280
        'y': 40
      get_sensitive_value_python_2:
        x: 320
        'y': 360
      get_sensitive_value_1:
        x: 160
        'y': 40
      get_sensitive_input_var_value:
        x: 1200
        'y': 280
      get_keyname_1:
        x: 440
        'y': 40
      is_sensitive_1:
        x: 40
        'y': 200
      array_iterator:
        x: 480
        'y': 200
      create_component_template_property:
        x: 720
        'y': 40
      set_csa_confidential_value_true_1:
        x: 40
        'y': 360
      get_keyvalue:
        x: 720
        'y': 280
      set_csa_confidential_value_false_1:
        x: 160
        'y': 200
      get_sensitive_value_python:
        x: 1120
        'y': 40
      get_sensitive_value:
        x: 840
        'y': 280
    results:
      SUCCESS:
        c24137a6-111f-83a4-cb98-ee4ece4c1920:
          x: 440
          'y': 360

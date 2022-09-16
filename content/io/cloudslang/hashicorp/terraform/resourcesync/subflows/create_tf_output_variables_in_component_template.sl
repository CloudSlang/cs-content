namespace: io.cloudslang.hashicorp.terraform.resourcesync.subflows
flow:
  name: create_tf_output_variables_in_component_template
  inputs:
    - tf_output_variable_key_list
    - component_template_id
    - host
    - tenant_id
    - x_auth_token
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - tf_template_vcs_repo_identifier
  workflow:
    - array_value:
        do:
          io.cloudslang.base.utils.do_nothing:
            - array_value: '${tf_output_variable_key_list}'
        publish:
          - array_value_output: "${array_value.replace(\"[\",\"\").replace(\"]\",\"\").replace(\"'\",\"\")}"
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - set_tf_output_property:
        do:
          io.cloudslang.base.utils.do_nothing:
            - input_0: "${'tf_output_'+key_name}"
        publish:
          - updated_output_keyname: '${input_0}'
        navigate:
          - SUCCESS: create_component_template_property
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${array_value_output}'
        publish:
          - key_name: '${result_string}'
        navigate:
          - HAS_MORE: set_tf_output_property
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - create_component_template_property:
        do:
          io.cloudslang.microfocus.content.create_component_template_property:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${x_auth_token}'
                sensitive: true
            - template_id: '${component_template_id}'
            - property_name: '${updated_output_keyname}'
        publish:
          - return_result
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      array_value:
        x: 200
        'y': 40
      create_component_template_property:
        x: 520
        'y': 240
      list_iterator:
        x: 360
        'y': 40
        navigate:
          8b6965dd-57ad-a18d-07df-d5d132da4710:
            targetId: c24137a6-111f-83a4-cb98-ee4ece4c1920
            port: NO_MORE
      set_tf_output_property:
        x: 360
        'y': 240
    results:
      SUCCESS:
        c24137a6-111f-83a4-cb98-ee4ece4c1920:
          x: 520
          'y': 40

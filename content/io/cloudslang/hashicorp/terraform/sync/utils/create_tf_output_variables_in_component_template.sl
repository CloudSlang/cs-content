namespace: io.cloudslang.hashicorp.terraform.sync.utils
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
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - input_0: "${'tf_output_'+removed_keyname}"
        publish:
          - updated_output_keyname: '${input_0}'
        navigate:
          - SUCCESS: create_component_template_property_1
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${striped_array_3}'
        publish:
          - key_name: '${result_string}'
        navigate:
          - HAS_MORE: do_nothing
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - create_component_template_property_1:
        do:
          io.cloudslang.microfocus.content.create_component_template_property:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${x_auth_token}'
                sensitive: true
            - template_id: '${component_template_id}'
            - property_name: '${updated_output_keyname}'
            - property_value: default
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
      create_component_template_property_1:
        x: 520
        'y': 240
      array_value:
        x: 200
        'y': 40
      list_iterator:
        x: 360
        'y': 40
        navigate:
          8b6965dd-57ad-a18d-07df-d5d132da4710:
            targetId: c24137a6-111f-83a4-cb98-ee4ece4c1920
            port: NO_MORE
      do_nothing:
        x: 360
        'y': 240
    results:
      SUCCESS:
        c24137a6-111f-83a4-cb98-ee4ece4c1920:
          x: 520
          'y': 40

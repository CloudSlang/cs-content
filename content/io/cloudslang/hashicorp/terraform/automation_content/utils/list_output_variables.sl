namespace: io.cloudslang.hashicorp.terraform.automation_content.utils
flow:
  name: list_output_variables
  inputs:
    - property_value_list
    - state_version_id
    - hosted_state_download_url
    - service_component_id
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - user_identifier
  workflow:
    - extract_state_details:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${hosted_state_download_url}'
            - auth_type: anonymous
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
        publish:
          - state_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${tf_output_list}'
            - separator: ','
        publish:
          - list_items: '${result_string}'
        navigate:
          - HAS_MORE: get_keyname_and_keyvalue
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - remove_tf_output:
        do:
          io.cloudslang.base.strings.remove:
            - origin_string: '${striped_key_name}'
            - text: tf_output_
        publish:
          - striped_output_keyname: '${new_string}'
        navigate:
          - SUCCESS: get_values_v2
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${state_result}'
            - json_path: $.outputs
        publish:
          - output_results: '${return_result}'
        navigate:
          - SUCCESS: get_output_keyname_python
          - FAILURE: on_failure
    - get_values_v2:
        do:
          io.cloudslang.base.maps.get_values_v2:
            - map: '${state_output_variables_list}'
            - key: '${striped_output_keyname}'
            - pair_delimiter: ':'
            - entry_delimiter: ','
            - map_start: '{'
            - map_end: '}'
            - element_wrapper: "'"
            - strip_whitespaces: 'true'
        publish:
          - updated_keyvalue: '${return_result}'
        navigate:
          - SUCCESS: add_or_update_service_component_property
          - FAILURE: on_failure
    - get_output_keyname_python:
        do:
          io.cloudslang.hashicorp.terraform.automation_content.utils.python_operations.get_output_keyname_python:
            - output_results: '${output_results}'
        publish:
          - state_output_variables_list: '${result}'
        navigate:
          - SUCCESS: get_tf_output_list_python
    - get_tf_output_list_python:
        do:
          io.cloudslang.hashicorp.terraform.automation_content.utils.get_tf_output_list_python:
            - property_value_list: '${property_value_list}'
        publish:
          - tf_output_list
        navigate:
          - SUCCESS: list_iterator
    - get_keyname_and_keyvalue:
        do:
          io.cloudslang.base.utils.do_nothing:
            - key_name: '${list_items.split(";")[0]}'
            - key_value: '${list_items.split(";")[1]}'
            - is_confidential: '${list_items.split(";")[2]}'
        publish:
          - striped_key_name: "${key_name.strip(' ')}"
          - key_value
        navigate:
          - SUCCESS: remove_tf_output
          - FAILURE: on_failure
    - add_or_update_service_component_property:
        do:
          io.cloudslang.microfocus.content.add_or_update_service_component_property:
            - component_id: '${service_component_id}'
            - user_identifier: '${user_identifier}'
            - property_name: '${property_name}'
            - property_values: '${property_value}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
  outputs:
    - striped_output_keyname: '${striped_output_keyname}'
    - updated_keyvalue: '${updated_keyvalue}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_tf_output_list_python:
        x: 400
        'y': 80
      json_path_query:
        x: 160
        'y': 80
      get_output_keyname_python:
        x: 280
        'y': 80
      list_iterator:
        x: 560
        'y': 80
        navigate:
          c86dc5bc-eff5-a254-f234-044952b4e3ec:
            targetId: f30f1fa9-eca1-283d-7473-5ed1ea062825
            port: NO_MORE
      get_values_v2:
        x: 480
        'y': 280
      remove_tf_output:
        x: 320
        'y': 280
      extract_state_details:
        x: 40
        'y': 80
      get_keyname_and_keyvalue:
        x: 160
        'y': 280
      add_or_update_service_component_property:
        x: 640
        'y': 280
    results:
      SUCCESS:
        f30f1fa9-eca1-283d-7473-5ed1ea062825:
          x: 840
          'y': 80

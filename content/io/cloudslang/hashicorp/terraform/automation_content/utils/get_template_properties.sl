namespace: io.cloudslang.hashicorp.terraform.automation_content.utils
flow:
  name: get_template_properties
  inputs:
    - user_identifier
    - artifact_id
    - property_names:
        required: false
    - connect_timeout:
        default: "${get_sp('io.cloudslang.microfocus.content.connect_timeout')}"
        required: false
    - socket_timeout:
        default: "${get_sp('io.cloudslang.microfocus.content.socket_timeout')}"
        required: false
    - worker_group:
        default: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        required: false
    - proxy_host:
        default: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
        required: false
    - proxy_port:
        default: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
        required: false
    - proxy_username:
        default: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
        required: false
    - proxy_password:
        default: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
        required: false
        sensitive: true
    - trust_all_roots:
        default: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
        required: false
    - x_509_hostname_verifier:
        default: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
        required: false
    - trust_keystore:
        default: "${get_sp('io.cloudslang.microfocus.content.trust_keystore')}"
        required: false
    - trust_password:
        default: "${get_sp('io.cloudslang.microfocus.content.trust_password')}"
        required: false
        sensitive: true
  workflow:
    - get_artifact_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_uri')+'/artifact/'+artifact_id+'/resolveProperties?userIdentifier='+user_identifier+'&view=propertyvalue'}"
            - username: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
            - password:
                value: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_password')}"
                sensitive: true
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - worker_group: '${worker_group}'
        publish:
          - property_xml: '${return_result}'
          - error_message
          - return_code
          - return_result
        navigate:
          - SUCCESS: is_null
          - FAILURE: on_failure
    - is_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${property_names}'
            - property_value_list: ' '
        navigate:
          - IS_NULL: xpath_query
          - IS_NOT_NULL: list_iterator
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${property_names}'
            - separator: '|'
            - property_value_list: '${property_value_list}'
        publish:
          - property_name: '${result_string}'
          - property_value_list
        navigate:
          - HAS_MORE: xpath_query_1
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - xpath_query_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${property_xml}'
            - xpath_query: "${'/*/property[name=\"'+property_name+'\"]/values/value/text()'}"
        publish:
          - value: '${selected_value}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - add_element:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${property_value_list}'
            - element: "${property_name+';'+value+';'+confidential}"
            - delimiter: '|'
        publish:
          - property_value_list: '${return_result}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - xpath_query:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${property_xml}'
            - xpath_query: '/*/property/name/text()'
            - delimiter: '|'
            - property_value_list: ' '
        publish:
          - property_names: '${selected_value}'
          - return_result
          - return_code
          - error_message
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - string_equals:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${value}'
            - second_string: No match found
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: set_value
          - FAILURE: xpath_query_1_1
    - set_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - value: '${value}'
        publish:
          - value: ' '
        navigate:
          - SUCCESS: xpath_query_1_1
          - FAILURE: on_failure
    - xpath_query_1_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${property_xml}'
            - xpath_query: "${'/*/property[name=\"'+property_name+'\"]/confidential/text()'}"
        publish:
          - confidential: '${selected_value}'
        navigate:
          - SUCCESS: string_equals_1
          - FAILURE: on_failure
    - string_equals_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${confidential}'
            - second_string: No match found
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: set_value_1
          - FAILURE: add_element
    - set_value_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - confidential: '${confidential}'
        publish:
          - confidential: 'false'
        navigate:
          - SUCCESS: add_element
          - FAILURE: on_failure
  outputs:
    - property_value_list
    - return_code
    - status_code
    - return_result
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_value_1:
        x: 120
        'y': 480
      xpath_query:
        x: 360
        'y': 80
      xpath_query_1_1:
        x: 240
        'y': 600
      string_equals:
        x: 200
        'y': 400
      list_iterator:
        x: 200
        'y': 240
        navigate:
          60b7d4b2-4c8a-4e10-d536-d84cc0a115b4:
            targetId: 5b54c36a-5622-0fc0-cdb5-369261d21921
            port: NO_MORE
      set_value:
        x: 400
        'y': 600
      xpath_query_1:
        x: 360
        'y': 400
      is_null:
        x: 200
        'y': 80
      add_element:
        x: 40
        'y': 240
      get_artifact_details:
        x: 40
        'y': 80
      string_equals_1:
        x: 40
        'y': 600
    results:
      SUCCESS:
        5b54c36a-5622-0fc0-cdb5-369261d21921:
          x: 480
          'y': 240

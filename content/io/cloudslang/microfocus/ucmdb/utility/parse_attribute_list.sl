namespace: io.cloudslang.microfocus.ucmdb.utility
flow:
  name: parse_attribute_list
  inputs:
    - attribute_list
    - json
    - attributes:
        default: ' '
        required: false
  workflow:
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${attribute_list}'
        publish:
          - attribute: '${result_string}'
        navigate:
          - HAS_MORE: json_path_query
          - NO_MORE: remove_by_index
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.' + attribute}"
        publish:
          - attribute_value: '${return_result}'
        navigate:
          - SUCCESS: add_element
          - FAILURE: on_failure
    - add_element:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${attributes}'
            - element: "${attribute + '=' + attribute_value}"
            - delimiter: ','
        publish:
          - attributes: '${return_result}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - remove_by_index:
        do:
          io.cloudslang.base.lists.remove_by_index:
            - list: '${attributes}'
            - element: '0'
            - delimiter: ','
        publish:
          - attributes: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - attributes_list: '${attributes}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      list_iterator:
        x: 129
        y: 97
      json_path_query:
        x: 530
        y: 96
      add_element:
        x: 345
        y: 308
      remove_by_index:
        x: 97
        y: 403
        navigate:
          2ee60863-7c66-fce8-4698-79d02033f23e:
            targetId: 8f96a361-cb9e-cdcd-7929-34037cf3d7c6
            port: SUCCESS
    results:
      SUCCESS:
        8f96a361-cb9e-cdcd-7929-34037cf3d7c6:
          x: 283
          y: 498

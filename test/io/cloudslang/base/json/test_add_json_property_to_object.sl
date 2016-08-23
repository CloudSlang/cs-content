namespace: io.cloudslang.base.json

imports:
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: test_add_json_property_to_object

  inputs:
    - json_object:
        default: "{}"
    - key
    - value
    - string_to_find:
        default: None
    - string_to_find_in_output:
        default: None
    - old_key:
        default: None
    - new_key:
        default: None
    - second_string:
        default: None

  workflow:
    - add_JSON_property_in_object:
        do:
          json.add_json_property_to_object:
            - json_object
            - key
            - value

        publish:
          - json_output
          - return_result
          - return_code
          - error_message

        navigate:
          - SUCCESS: verify_if_string_to_find_is_null
          - FAILURE: FAILURE

    - verify_if_string_to_find_is_null:
        do:
          strings.string_equals:
            - first_string: ${string_to_find}
            - second_string: None

        navigate:
          - SUCCESS: verify_new_JSON_added
          - FAILURE: verify_JSON_output

    - verify_JSON_output:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${json_output}
            - string_to_find

        publish:
          - return_result_verify_json_output: ${return_result}
          - return_code_verify_json_output: ${return_code}
          - error_message_verify_json_output: ${error_message}

        navigate:
          - SUCCESS: verify_if_new_string_added_is_null
          - FAILURE: FAILURE_verify_JSON_output

    - verify_if_new_string_added_is_null:
            do:
              strings.string_equals:
                - first_string: ${string_to_find_in_output}
                - second_string: None

            navigate:
              - SUCCESS: verify_if_old_key_is_null
              - FAILURE: verify_new_JSON_added

    - verify_new_JSON_added:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${json_output}
            - string_to_find: ${string_to_find_in_output}

        publish:
          - return_result_verify_new_json_added: ${return_result}
          - return_code_verify_new_json_added: ${return_code}
          - error_message_verify_new_json_added: ${error_message}

        navigate:
          - SUCCESS: verify_if_old_key_is_null
          - FAILURE: FAILURE_verify_new_JSON_added

    - verify_if_old_key_is_null:
        do:
          strings.string_equals:
            - first_string: ${old_key}
            - second_string: None
        navigate:
          - SUCCESS: verify_if_new_key_is_null
          - FAILURE: verify_old_key

    - verify_old_key:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${json_output}
            - string_to_find: ${old_key}
        publish:
          - return_result_verify_old_key: ${return_result}
          - return_code_verify_old_key: ${return_code}
          - error_message_verify_old_key: ${error_message}

        navigate:
          - SUCCESS: verify_if_new_key_is_null
          - FAILURE: FAILURE_verify_old_key

    - verify_if_new_key_is_null:
        do:
          strings.string_equals:
            - first_string: ${new_key}
            - second_string: None
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: verify_new_key

    - verify_new_key:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${json_output}
            - string_to_find: ${new_key}

        publish:
          - return_result_verify_new_key: ${return_result}
          - return_code_verify_new_key: ${return_code}
          - error_message_verify_new_key: ${error_message}

        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE_verify_new_key

  outputs:
    - json_output
    - return_result
    - return_code
    - error_message
    - return_result_verify_json_output
    - return_code_verify_json_output
    - error_message_verify_json_output
    - return_result_verify_new_json_added
    - return_code_verify_new_json_added
    - error_message_verify_new_json_added
    - return_result_verify_old_key
    - return_code_verify_old_key
    - error_message_verify_old_key
    - return_result_verify_new_key
    - return_code_verify_new_key
    - error_message_verify_new_key

  results:
    - SUCCESS
    - FAILURE
    - FAILURE_verify_JSON_output
    - FAILURE_verify_new_JSON_added
    - FAILURE_verify_old_key
    - FAILURE_verify_new_key

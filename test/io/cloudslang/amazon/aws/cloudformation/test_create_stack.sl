namespace: io.cloudslang.amazon.aws.cloudformation

imports:
  cf: io.cloudslang.amazon.aws.cloudformation
  strings: io.cloudslang.base.strings

flow:
  name: test_create_stack

  inputs:
    - identity
    - credential
    - region
    - stack_name
    - template_body
    - capabilities
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - expected_return_code
    - expected_return_result

  outputs:
    - return_result
    - exception

  workflow:
    - create_stack_positive:
        do:
          cf.create_stack:
            - identity
            - credential
            - region
            - stack_name
            - template_body
            - capabilities
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_return_code
          - FAILURE: CREATE_STACK_FAILURE

    - check_return_code:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_code}
            - string_to_find: ${expected_return_code}
        navigate:
          - SUCCESS: check_return_result
          - FAILURE: CHECK_RESULTS_FAILURE

    - check_return_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: ${expected_return_result}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULTS_FAILURE

  results:
    - SUCCESS
    - CREATE_STACK_FAILURE
    - CHECK_RESULTS_FAILURE
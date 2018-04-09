namespace: io.cloudslang.amazon.aws.cloudformation

imports:
  cf: io.cloudslang.amazon.aws.cloudformation
  strings: io.cloudslang.base.strings

flow:
  name: test_list_stacks

  inputs:
    - identity
    - credential
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - expected_return_result
    - expected_return_code

  outputs:
    - return_result
    - exception

  workflow:
    - list_stacks:
        do:
          cf.list_stacks:
            - identity
            - credential
            - region
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
          - FAILURE: LIST_STACKS_FAILURE

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
    - LIST_STACKS_FAILURE
    - CHECK_RESULTS_FAILURE
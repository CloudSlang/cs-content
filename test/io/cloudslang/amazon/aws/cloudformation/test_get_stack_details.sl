namespace: io.cloudslang.amazon.aws.cloudformation

imports:
    cf: io.cloudslang.amazon.aws.cloudformation
    strings: io.cloudslang.base.strings
    lists: io.cloudslang.base.lists

flow:
  name: test_get_stack_details

  inputs:
    - identity
    - credential
    - region
    - stack_name
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
    - stack_id
    - stack_status
    - stack_status_reason
    - stack_creation_time
    - stack_description
    - stack_outputs
    - stack_resources

  workflow:
    - get_stack_details_positive:
        do:
          cf.get_stack_details:
            - identity
            - credential
            - region
            - stack_name
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - stack_id
          - stack_status
          - stack_status_reason
          - stack_creation_time
          - stack_description
          - stack_outputs
          - stack_resources
          - return_code
          - exception
        navigate:
          - SUCCESS: check_return_code
          - FAILURE: GET_STACK_DETAILS_STACK_FAILURE

    - check_return_code:
        do:
          lists.compare_lists:
            - list_1: ${return_code}
            - list_2: ${expected_return_code}
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
    - GET_STACK_DETAILS_STACK_FAILURE
    - CHECK_RESULTS_FAILURE

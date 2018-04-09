namespace: io.cloudslang.amazon.aws.lambda

imports:
    lambda: io.cloudslang.amazon.aws.lambda
    strings: io.cloudslang.base.strings

flow:
  name: test_invoke_lambda

  inputs:
    - identity
    - credential
    - region
    - function
    - function_payload
    - qualifier
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - expected_return_code

  outputs:
    - return_result
    - exception

  workflow:
    - invoke_lambda:
        do:
          lambda.invoke_lambda:
            - identity
            - credential
            - region
            - function
            - function_payload
            - qualifier
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
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULTS_FAILURE

  results:
    - SUCCESS
    - CREATE_STACK_FAILURE
    - CHECK_RESULTS_FAILURE
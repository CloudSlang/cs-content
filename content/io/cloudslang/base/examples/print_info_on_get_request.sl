namespace: io.cloudslang.base.examples

imports:
  base: io.cloudslang.base.network.rest

flow:
  name: print_info_on_get_request
  inputs:
    - url:
        required: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - auth_type:
        default: "anonymous"
    - content_type:
        default: "application/json"

  workflow:
    - http_client_action_get:
        do:
          io.cloudslang.base.network.rest.http_client_get:
            - url
            - auth_type
            - content_type
        publish:
          - json_body: ${return_result}
          - returncode : ${return_code}

    - print_info:
        do:
          print_info:
            - json_input: ${json_body}
            - json_code : ${returncode}
        publish:
          - json_type
          - json_size
          - return_code
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

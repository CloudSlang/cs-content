####################################################
#!!
#! @description: Performs an REST API call in order to get the Central CSRF Token using a REST API Get call.
#! @input host: the host where the Central is installed and running
#! @input port: optional - the port where the central GUI is exposed - Default: '8080'
#! @input protocol: optional - the protocol used to connect to Central - Valid: 'http', 'https' - Default: 'http'
#! @input username: optional - the username needed to connect to Central; for NTLM authentication - Format: 'domain\user' - Default: ''
#! @input password: optional - the password associated with <username> input used for authentication - Default: ''
#! @output return_result: response of operation in case of success, error message otherwise
#! @output error_message: return_result if statusCode is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by operation
#! @output csrf_token: Central CSRF token
#!!#
####################################################

namespace: io.cloudslang.operations_orchestration.samples

imports:
  rest: io.cloudslang.base.network.rest
  utils: io.cloudslang.base.network.utils

flow:
  name: get_Central_CSRF_token
  inputs:
    - host
    - port:
        default: '8080'
        required: false
    - protocol:
        default: 'http'
        required: false
    - username:
        default: ''
        required: false
    - password:
        default: ''
        required: false

  workflow:
    - get_central_version:
        do:
          rest.http_client_get:
            - url: ${protocol + '://' + host + ':' + port + '/oo/rest/version/'}
            - username
            - password
            - headers: 'Authorization: Basic'
            - content_type: 'application/json'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
        navigate:
          - SUCCESS: get_CSRF_token_value
          - FAILURE: FAILURE

    - get_CSRF_token_value:
        do:
          utils.get_header_value:
            - response_headers
            - header_name: 'X-CSRF-TOKEN'
        publish:
          - token: ${result}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - response_headers
    - token

  results:
    - SUCCESS
    - FAILURE
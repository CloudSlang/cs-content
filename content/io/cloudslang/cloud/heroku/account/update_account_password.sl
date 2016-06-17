####################################################
#!!
#! @description: Performs a REST API call to update the HEROKU password.
#! @input username: Heroku username
#!                  example: 'someone@mailprovider.com'
#! @input password: Heroku <username> account password
#!                  optional
#!                  default: None
#! @input new_password: new password for <username> account
#!                      optional
#!                      default: None
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#! @result SUCCESS: update Heroku account password was successfully executed
#! @result ADD_PASSWORD_FAILURE: insert 'password' key:value pair in JSON body failed
#! @result ADD_NEW_PASSWORD_FAILURE: insert 'new_password' key:value pair in JSON body failed
#! @result UPDATE_ACCOUNT_PASSWORD_FAILURE: update Heroku password account REST API call failed
#!!#
####################################################

namespace: io.cloudslang.cloud.heroku.account

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: update_account_password
  inputs:
    - username
    - password:
        default: None
        required: false
        sensitive: true
    - new_password:
        default: None
        required: false
        sensitive: true

  workflow:
    - validate_password_input:
        do:
          strings.string_equals:
            - first_string: ${password}
            - second_string: None
        navigate:
          - SUCCESS: validate_new_password_input
          - FAILURE: add_password_value

    - add_password_value:
        do:
          json.add_value:
            - json_input: "{}"
            - json_path: ['password']
            - value: ${password}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_new_password_input
          - FAILURE: ADD_PASSWORD_FAILURE

    - validate_new_password_input:
        do:
          strings.string_equals:
            - first_string: ${new_password}
            - second_string: None
        navigate:
          - SUCCESS: update_account_password
          - FAILURE: add_new_password_value

    - add_new_password_value:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['new_password']
            - value: ${new_password}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: update_account_password
          - FAILURE: ADD_NEW_PASSWORD_FAILURE

    - update_account_password:
        do:
          rest.http_client_patch:
            - url: "https://api.heroku.com/account"
            - username
            - password
            - headers: "Accept:application/vnd.heroku+json; version=3"
            - body: ${body_json}
            - content_type: "application/json"

        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: UPDATE_ACCOUNT_PASSWORD_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - ADD_PASSWORD_FAILURE
    - ADD_NEW_PASSWORD_FAILURE
    - UPDATE_ACCOUNT_PASSWORD_FAILURE

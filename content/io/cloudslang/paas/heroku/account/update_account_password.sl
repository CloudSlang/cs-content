#################################################### 
# This flow performs an REST API call in order to update the HEROKU password 
# 
# Inputs: 
#   - username - the Heroku username - Example: 'someone@mailprovider.com'
#   - password - optional - the Heroku <username> account password - Default: None
#   - new_password - optional - the new password for the <username> account - Default: None
#
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise 
#   - error_message - return_result if status_code is not '200'
#   - return_code - '0' if success, '-1' otherwise 
#   - status_code - the code returned by the operation 
#
# Results:
#   - SUCCESS - the update Heroku account password was successfully executed
#   - ADD_PASSWORD_FAILURE - insert 'password' key:value pair in JSON body failed
#   - ADD_NEW_PASSWORD_FAILURE - insert 'new_password' key:value pair in JSON body failed
#   - UPDATE_ACCOUNT_PASSWORD_FAILURE - the update Heroku password account REST API call failed
####################################################

namespace: io.cloudslang.paas.heroku.account

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: update_account_password
  inputs:
    - username
    - password:
        default: None
        required: false
    - new_password:
        default: None
        required: false

  workflow:
    - validate_password_input:
        do:
          strings.string_equals:
            - first_string: ${password}
            - second_string: None
        navigate:
          SUCCESS: validate_new_password_input
          FAILURE: add_password_value

    - add_password_value:
        do:
          json.add_value:
            - json_input: "{}"
            - json_path: ['password']
            - value: ${password}
        publish:
          - json_output
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: validate_new_password_input
          FAILURE: ADD_PASSWORD_FAILURE

    - validate_new_password_input:
        do:
          strings.string_equals:
            - first_string: ${new_password}
            - second_string: None
        navigate:
          SUCCESS: update_account_password
          FAILURE: add_new_password_value

    - add_new_password_value:
        do:
          json.add_value:
            - json_input: ${json_output}
            - json_path: ['new_password']
            - value: ${new_password}
        publish:
          - json_output
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: update_account_password
          FAILURE: ADD_NEW_PASSWORD_FAILURE

    - update_account_password:
        do:
          rest.http_client_patch:
            - url: "https://api.heroku.com/account"
            - username
            - password
            - headers: "Accept:application/vnd.heroku+json; version=3"
            - body: ${json_output}
            - content_type: "application/json"
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: SUCCESS
          FAILURE: UPDATE_ACCOUNT_PASSWORD_FAILURE

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
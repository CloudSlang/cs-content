###################################################################################################
#!!
#! @description: Performs a REST API call in order to update the Heroku account.
#! @input username: Heroku username
#!                  example: 'someone@mailprovider.com'
#! @input password: Heroku <username> account password
#!                  optional
#!                  default: None
#! @input allow_tracking: whether to allow third party web activity tracking
#!                        optional
#!                        default: True
#! @input beta: whether allowed to utilize beta Heroku features
#!              optional
#!              default: False
#! @input account_owner_name: full name of account owner
#!                            optional
#!                            default: None
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#! @result SUCCESS: update Heroku account was successfully executed
#! @result ADD_ALLOW_TRACKING_FAILURE: insert 'allow_tracking' key:value pair in JSON body failed
#! @result ADD_BETA_FAILURE: insert 'beta' key:value pair in JSON body failed
#! @result ADD_ACCOUNT_OWNER_NAME_FAILURE: insert 'name' key:value pair in JSON body failed
#! @result UPDATE_ACCOUNT_FAILURE: update Heroku account REST API call failed
#!!#
###################################################################################################

namespace: io.cloudslang.cloud.heroku.account

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: update_account
  inputs:
    - username
    - password:
        default: None
        required: false
        sensitive: true
    - allow_tracking:
        default: True
        required: false
    - beta:
        default: False
        required: false
    - account_owner_name:
        default: None
        required: false

  workflow:
    - add_allow_tracking_value:
        do:
          json.add_value:
            - json_input: "{}"
            - json_path: ['allow_tracking']
            - value: ${bool(allow_tracking)}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: add_beta_value
          - FAILURE: ADD_ALLOW_TRACKING_FAILURE

    - add_beta_value:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['beta']
            - value: ${bool(beta)}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_account_owner_name_input
          - FAILURE: ADD_BETA_FAILURE

    - validate_account_owner_name_input:
        do:
          strings.string_equals:
            - first_string: ${account_owner_name}
            - second_string: None
        navigate:
          - SUCCESS: update_account
          - FAILURE: insert_account_owner_name

    - insert_account_owner_name:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['name']
            - value: ${account_owner_name}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: update_account
          - FAILURE: ADD_ACCOUNT_OWNER_NAME_FAILURE

    - update_account:
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
          - FAILURE: UPDATE_ACCOUNT_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - ADD_ALLOW_TRACKING_FAILURE
    - ADD_BETA_FAILURE
    - ADD_ACCOUNT_OWNER_NAME_FAILURE
    - UPDATE_ACCOUNT_FAILURE

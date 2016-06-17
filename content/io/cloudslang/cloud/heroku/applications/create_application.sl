####################################################
#!!
#! @description: Performs a REST API call to create a Heroku application.
#! @input username: Heroku username
#!                  example: 'someone@mailprovider.com'
#! @input password: Heroku password used for authentication
#! @input name: name of application; if not provided, name will be generate by Heroku
#!              optional
#!              default: None
#! @input region: unique identifier or name of region
#!                optional
#!                default: None
#!                example: 'us'
#! @input stack: optional unique identifier or name of stack
#!               optional
#!               default: None
#!               example: 'cedar-14'
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '201'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#! @output id: ID of the newly created application
#!             example: '4517af43-3564-4c74-b0d0-da9344ee32c1'
#! @output new_name: name of the new created application; useful when <name> input is not provided
#!               example: 'arcane-fortress-9257'
#! @output created_at: exact time when application was created
#!                     example: '2016-01-04T14:49:53Z'
#! @result SUCCESS: application was created successfully
#! @result CREATE_EMPTY_JSON_FAILURE: create empty JSON step failed
#! @result ADD_NAME_FAILURE: insert 'name' key:value pair in JSON body failed
#! @result ADD_REGION_FAILURE: insert 'region' key:value pair in JSON body failed
#! @result ADD_STACK_FAILURE: insert 'stack' key:value pair in JSON body failed
#! @result CREATE_APPLICATION_FAILURE: create Heroku application REST API call failed
#! @result GET_ID_FAILURE: ID of newly created application could not be retrieved from create REST API call response
#! @result GET_NAME_FAILURE: name of newly created application could not be retrieved from create REST API call response
#! @result GET_CREATED_AT_FAILURE: time when newly created application was created could not be retrieved from the create REST API call response
#!!#
####################################################

namespace: io.cloudslang.cloud.heroku.applications

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: create_application
  inputs:
    - username:
        sensitive: true
    - password:
        sensitive: true
    - name:
        default: None
        required: false
    - region:
        default: None
        required: false
    - stack:
        default: None
        required: false

  workflow:
    - create_empty_json:
        do:
          json.add_value:
            - json_input: "{}"
            - json_path: []
            - value: ''
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_name_input
          - FAILURE: CREATE_EMPTY_JSON_FAILURE

    - validate_name_input:
        do:
          strings.string_equals:
            - first_string: ${name}
            - second_string: None
        navigate:
          - SUCCESS: validate_region_input
          - FAILURE: add_name

    - add_name:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['name']
            - value: ${name}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_region_input
          - FAILURE: ADD_NAME_FAILURE

    - validate_region_input:
        do:
          strings.string_equals:
            - first_string: ${region}
            - second_string: None
        navigate:
          - SUCCESS: validate_stack_input
          - FAILURE: add_region

    - add_region:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['region']
            - value: ${region}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_stack_input
          - FAILURE: ADD_REGION_FAILURE

    - validate_stack_input:
        do:
          strings.string_equals:
            - first_string: ${stack}
            - second_string: None
        navigate:
          - SUCCESS: create_application
          - FAILURE: add_stack

    - add_stack:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['stack']
            - value: ${stack}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: create_application
          - FAILURE: ADD_STACK_FAILURE

    - create_application:
        do:
          rest.http_client_post:
            - url: "https://api.heroku.com/apps"
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
          - SUCCESS: get_id
          - FAILURE: CREATE_APPLICATION_FAILURE

    - get_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['id']
        publish:
          - id: ${value}
        navigate:
          - SUCCESS: get_name
          - FAILURE: GET_ID_FAILURE

    - get_name:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['name']
        publish:
          - name: ${value}
        navigate:
          - SUCCESS: get_created_at
          - FAILURE: GET_NAME_FAILURE

    - get_created_at:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['created_at']
        publish:
          - created_at: ${value}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_CREATED_AT_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - id
    - new_name: ${name}
    - created_at

  results:
    - SUCCESS
    - CREATE_EMPTY_JSON_FAILURE
    - ADD_NAME_FAILURE
    - ADD_REGION_FAILURE
    - ADD_STACK_FAILURE
    - CREATE_APPLICATION_FAILURE
    - GET_ID_FAILURE
    - GET_NAME_FAILURE
    - GET_CREATED_AT_FAILURE

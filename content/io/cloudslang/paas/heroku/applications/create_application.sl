#################################################### 
# This flow performs an REST API call in order to create a Heroku application
# 
# Inputs: 
#   - username - the Heroku username - Example: 'someone@mailprovider.com'
#   - password - the Heroku used for authentication
#   - name - optional - the name of the application. If not provided then the name will be generate by Heroku
#                     - Default: None
#   - region - optional - the unique identifier or name of region - Example: 'us' - Default: None
#   - stack - optional - the unique identifier or name of stack - Example: 'cedar-14' - Default: None
#
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise 
#   - error_message - return_result if statusCode is not '201'
#   - return_code - '0' if success, '-1' otherwise 
#   - status_code - the code returned by the operation
#   - id - the id of the new created application - Example: '4517af43-3564-4c74-b0d0-da9344ee32c1'
#   - name - the name of the new created application. Useful when <name> input is not provided - Example: 'arcane-fortress-9257'
#   - created_at - the exact time when the application was created - Example: '2016-01-04T14:49:53Z'
#
# Results:
#   - SUCCESS - the application was successfully created
#   - CREATE_EMPTY_JSON_FAILURE - create empty json step failed
#   - ADD_NAME_FAILURE - insert 'name' key:value pair in JSON body failed
#   - ADD_REGION_FAILURE - insert 'region' key:value pair in JSON body failed
#   - ADD_STACK_FAILURE - insert 'stack' key:value pair in JSON body failed
#   - CREATE_APPLICATION_FAILURE - the create Heroku application REST API call failed
#   - GET_ID_FAILURE - the id of the newly created application could not be retrieved from the create REST API call response
#   - GET_NAME_FAILURE - the name of the newly created application could not be retrieved from the create REST API call response
#   - GET_CREATED_AT_FAILURE - the time when the newly application was created could not be retrieved from the create REST API call response
####################################################

namespace: io.cloudslang.paas.heroku.applications

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: create_application
  inputs:
    - username
    - password
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
          - json_output
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: validate_name_input
          FAILURE: CREATE_EMPTY_JSON_FAILURE

    - validate_name_input:
        do:
          strings.string_equals:
            - first_string: ${name}
            - second_string: None
        navigate:
          SUCCESS: validate_region_input
          FAILURE: add_name

    - add_name:
        do:
          json.add_value:
            - json_input: ${json_output}
            - json_path: ['name']
            - value: ${name}
        publish:
          - json_output
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: validate_region_input
          FAILURE: ADD_NAME_FAILURE

    - validate_region_input:
        do:
          strings.string_equals:
            - first_string: ${region}
            - second_string: None
        navigate:
          SUCCESS: validate_stack_input
          FAILURE: add_region

    - add_region:
        do:
          json.add_value:
            - json_input: ${json_output}
            - json_path: ['region']
            - value: ${region}
        publish:
          - json_output
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: validate_stack_input
          FAILURE: ADD_REGION_FAILURE

    - validate_stack_input:
        do:
          strings.string_equals:
            - first_string: ${stack}
            - second_string: None
        navigate:
          SUCCESS: create_application
          FAILURE: add_stack

    - add_stack:
        do:
          json.add_value:
            - json_input: ${json_output}
            - json_path: ['stack']
            - value: ${stack}
        publish:
          - json_output
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: create_application
          FAILURE: ADD_STACK_FAILURE

    - create_application:
        do:
          rest.http_client_post:
            - url: "https://api.heroku.com/apps"
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
          SUCCESS: get_id
          FAILURE: CREATE_APPLICATION_FAILURE

    - get_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['id']
        publish:
          - id: ${value}
        navigate:
          SUCCESS: get_name
          FAILURE: GET_ID_FAILURE

    - get_name:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['name']
        publish:
          - name: ${value}
        navigate:
          SUCCESS: get_created_at
          FAILURE: GET_NAME_FAILURE

    - get_created_at:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['created_at']
        publish:
          - created_at: ${value}
        navigate:
          SUCCESS: SUCCESS
          FAILURE: GET_CREATED_AT_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - id
    - name
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
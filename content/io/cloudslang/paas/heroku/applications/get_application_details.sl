#################################################### 
# This flow performs an REST API call in order to get the Heroku application details
# 
# Inputs: 
#   - username - the Heroku username - Example: 'someone@mailprovider.com'
#   - password - the Heroku used for authentication
#   - app_id_or_name - the name or the id of the Heroku application
#
# Outputs: 
#   - return_result - the response of the operation in case of success, the error message otherwise 
#   - error_message - return_result if statusCode is not '200' 
#   - return_code - '0' if success, '-1' otherwise 
#   - status_code - the code returned by the operation 
####################################################

namespace: io.cloudslang.paas.heroku.applications

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json

flow:
  name: get_application_details
  inputs:
    - username
    - password
    - app_id_or_name

  workflow:
    - get_application_details:
        do:
          rest.http_client_get:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name}
            - username
            - password
            - headers: "Accept:application/vnd.heroku+json; version=3"
            - content_type: "application/json"

        publish:
          - return_result
          - error_message
          - return_code
          - status_code

        navigate:
          SUCCESS: get_id
          FAILURE: GET_APPLICATION_DETAILS_FAILURE

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
          SUCCESS: get_region
          FAILURE: GET_NAME_FAILURE

    - get_region:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['region', 'name']
        publish:
          - region: ${value}
        navigate:
          SUCCESS: get_stack
          FAILURE: GET_REGION_FAILURE

    - get_stack:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['stack', 'name']
        publish:
          - stack: ${value}
        navigate:
          SUCCESS: get_created_at
          FAILURE: GET_STACK_FAILURE

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
    - region
    - stack
    - created_at

  results:
    - SUCCESS
    - GET_APPLICATION_DETAILS_FAILURE
    - GET_ID_FAILURE
    - GET_NAME_FAILURE
    - GET_REGION_FAILURE
    - GET_STACK_FAILURE
    - GET_CREATED_AT_FAILURE
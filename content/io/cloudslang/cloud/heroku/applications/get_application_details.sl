####################################################
#!!
#! @description: Performs a REST API call to get the Heroku application details.
#! @input username: Heroku username
#!                  example: 'someone@mailprovider.com'
#! @input password: Heroku password used for authentication
#! @input app_id_or_name: name or ID of the Heroku application
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#! @output id: ID of the application; useful when <app_id_or_name> is a name
#! @output name: name of the application; useful when <app_id_or_name> is an ID
#! @output region: region were application resides
#! @output stack: name of stack were application belongs
#! @output created_at: time when application was created
#!                     example: '2016-01-04T14:49:53Z'
#! @result SUCCESS: Heroku application details were successfully retrieved
#! @result GET_APPLICATION_DETAILS_FAILURE: Heroku application details could not be retrieved
#! @result GET_ID_FAILURE: ID of application could not be retrieved from the GET REST API call response
#! @result GET_NAME_FAILURE: name of application could not be retrieved from the GET REST API call response
#! @result GET_REGION_FAILURE: region were application resides could not be retrieved from the GET REST API call response
#! @result GET_STACK_FAILURE: stack name of application could not be retrieved from the GET REST API call response
#! @result GET_CREATED_AT_FAILURE: created_at application time could not be retrieved from the GET REST API call response
#!!#
####################################################

namespace: io.cloudslang.cloud.heroku.applications

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: get_application_details
  inputs:
    - username:
        sensitive: true
    - password:
        sensitive: true
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
          - SUCCESS: get_id
          - FAILURE: GET_APPLICATION_DETAILS_FAILURE

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
          - SUCCESS: get_region
          - FAILURE: GET_NAME_FAILURE

    - get_region:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['region', 'name']
        publish:
          - region: ${value}
        navigate:
          - SUCCESS: get_stack
          - FAILURE: GET_REGION_FAILURE

    - get_stack:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['stack', 'name']
        publish:
          - stack: ${value}
        navigate:
          - SUCCESS: get_created_at
          - FAILURE: GET_STACK_FAILURE

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

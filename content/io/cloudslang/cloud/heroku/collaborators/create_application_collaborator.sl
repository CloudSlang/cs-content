####################################################
#!!
#! @description: Performs a REST API call to create a Heroku collaborator on a specified application.
#! @input username: Heroku username
#!                  example: 'someone@mailprovider.com'
#! @input password: Heroku password used for authentication
#! @input app_id_or_name: ID or name of the Heroku application
#! @input user: unique identifier or email address of account of a new collaborator
#!              example: '01234567-89ab-cdef-0123-456789abcdef' or 'username@example.com'
#! @input silent: whether to suppress email invitation when creating collaborator
#!                optional
#!                default: False
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '201'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#! @output id: ID of the newly created application collaborator
#!             example: '4517af43-3564-4c74-b0d0-da9344ee32c1'
#! @output created_at: exact time when application collaborator was created
#!                     example: '2016-01-04T14:49:53Z'
#! @result SUCCESS: application collaborator was successfully created/added
#! @result ADD_SILENT_VALUE_FAILURE: insert 'silent' key:value pair in a empty JSON step failed
#! @result INSERT_USER_VALUE_FAILURE: insert 'user' key:value pair in JSON body failed
#! @result CREATE_APPLICATION_COLLABORATOR_FAILURE: create Heroku application collaborator REST API call failed
#! @result GET_ID_FAILURE: ID of newly created application could not be retrieved from create REST API call response
#! @result GET_CREATED_AT_FAILURE: time when newly created application was created could not be retrieved from create REST API call response
#!!#
####################################################

namespace: io.cloudslang.cloud.heroku.collaborators

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: create_application_collaborator
  inputs:
    - username
    - password:
        sensitive: true
    - app_id_or_name
    - user
    - silent:
        default: False
        required: false

  workflow:
    - add_silent_value:
        do:
          json.add_value:
            - json_input: "{}"
            - json_path: ['silent']
            - value: ${bool(silent)}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: insert_user_value
          - FAILURE: ADD_SILENT_VALUE_FAILURE

    - insert_user_value:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['user']
            - value: ${user}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: create_application_collaborator
          - FAILURE: INSERT_USER_VALUE_FAILURE

    - create_application_collaborator:
        do:
          rest.http_client_post:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name + '/collaborators'}
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
          - FAILURE: CREATE_APPLICATION_COLLABORATOR_FAILURE

    - get_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['id']
        publish:
          - id: ${value}
        navigate:
          - SUCCESS: get_created_at
          - FAILURE: GET_ID_FAILURE

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
    - created_at

  results:
    - SUCCESS
    - ADD_SILENT_VALUE_FAILURE
    - INSERT_USER_VALUE_FAILURE
    - CREATE_APPLICATION_COLLABORATOR_FAILURE
    - GET_ID_FAILURE
    - GET_CREATED_AT_FAILURE

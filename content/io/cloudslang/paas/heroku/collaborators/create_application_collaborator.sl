#################################################### 
# This flow performs an REST API call in order to create a Heroku collaborator on a specified application
# 
# Inputs: 
#   - username - the Heroku username - Example: 'someone@mailprovider.com'
#   - password - the Heroku used for authentication
#   - app_id_or_name - the name of the Heroku application
#   - user - the unique identifier or email address of account of a new collaborator
#          - Example: '01234567-89ab-cdef-0123-456789abcdef' or 'username@example.com'
#   - silent - optional - whether to suppress email invitation when creating collaborator - Default: False
#
# Outputs: 
#   - return_result - the response of the operation in case of success, the error message otherwise 
#   - error_message - return_result if statusCode is not '200' 
#   - return_code - '0' if success, '-1' otherwise 
#   - status_code - the code returned by the operation
#   - id - the id of the new created application collaborator - Example: '4517af43-3564-4c74-b0d0-da9344ee32c1'
#   - created_at - the exact time when the application collaborator was created - Example: '2016-01-04T14:49:53Z'
#
# Results:
#   - SUCCESS - the application collaborator was successfully created/added
#   - ADD_SILENT_VALUE_FAILURE - insert 'silent' key:value pair in a empty JSON step failed
#   - INSERT_USER_VALUE_FAILURE - insert 'user' key:value pair in JSON body failed
#   - CREATE_APPLICATION_COLLABORATOR_FAILURE - the create Heroku application collaborator REST API call failed
#   - GET_ID_FAILURE - the id of the newly created application could not be retrieved from the create REST API call response
#   - GET_CREATED_AT_FAILURE - the time when the newly application was created could not be retrieved from the create REST API call response
####################################################

namespace: io.cloudslang.paas.heroku.collaborators

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json

flow:
  name: create_application_collaborator
  inputs:
    - username
    - password
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
          - json_output
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: insert_user_value
          FAILURE: ADD_SILENT_VALUE_FAILURE

    - insert_user_value:
        do:
          json.add_value:
            - json_input: ${json_output}
            - json_path: ['user']
            - value: ${user}
        publish:
          - json_output
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: create_application_collaborator
          FAILURE: INSERT_USER_VALUE_FAILURE

    - create_application_collaborator:
        do:
          rest.http_client_post:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name + '/collaborators'}
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
          FAILURE: CREATE_APPLICATION_COLLABORATOR_FAILURE

    - get_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['id']
        publish:
          - id: ${value}
        navigate:
          SUCCESS: get_created_at
          FAILURE: GET_ID_FAILURE

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
    - created_at

  results:
    - SUCCESS
    - ADD_SILENT_VALUE_FAILURE
    - INSERT_USER_VALUE_FAILURE
    - CREATE_APPLICATION_COLLABORATOR_FAILURE
    - GET_ID_FAILURE
    - GET_CREATED_AT_FAILURE
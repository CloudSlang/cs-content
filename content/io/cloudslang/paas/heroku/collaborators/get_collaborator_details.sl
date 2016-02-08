#################################################### 
#!!
#! @description: This flow performs an REST API call in order to get the details of a specified Heroku collaborator
#! @input username: the Heroku username - Example: 'someone@mailprovider.com'
#! @input password: the Heroku used for authentication
#! @input app_id_or_name: the name or the id of the Heroku application that the collaborator is associated
#! @input collaborator_email_or_id: the email or the id of the collaborator
#! @output return_result: the response of the operation in case of success, the error message otherwise
#! @output error_message: return_result if statusCode is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: the code returned by the operation
#! @output id: the id of the collaborator. Useful when <collaborator_email_or_id> is a name
#! @output created_at: the time when collaborator was created/added - Example: '2016-01-04T14:49:53Z'
#! @output updated_at: the time when the collaborator was last time updated - Example: '2016-01-04T14:49:53Z'
#! @result SUCCESS: the Heroku collaborator details were successfully retrieved
#! @result GET_COLLABORATOR_DETAILS_FAILURE: the Heroku collaborator details could not be retrieved
#! @result GET_COLLABORATOR_ID_FAILURE: the id of collaborator could not be retrieved from the get REST API call response
#! @result GET_CREATED_AT_FAILURE: the created_at collaborator time could not be retrieved from the get REST API call response
#! @result GET_UPDATED_AT_FAILURE: the updated_at collaborator time could not be retrieved from the get REST API call response
#!!#
####################################################

namespace: io.cloudslang.paas.heroku.collaborators

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json

flow:
  name: get_collaborator_details
  inputs:
    - username
    - password
    - app_id_or_name
    - collaborator_email_or_id

  workflow:
    - details_app_collaborator:
        do:
          rest.http_client_get:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name +'/collaborators/' + collaborator_email_or_id}
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
          FAILURE: GET_COLLABORATOR_DETAILS_FAILURE

    - get_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['id']
        publish:
          - id: ${value}
        navigate:
          SUCCESS: get_created_at
          FAILURE: GET_COLLABORATOR_ID_FAILURE

    - get_created_at:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['created_at']
        publish:
          - created_at: ${value}
        navigate:
          SUCCESS: get_updated_at
          FAILURE: GET_CREATED_AT_FAILURE

    - get_updated_at:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['updated_at']
        publish:
          - updated_at: ${value}
        navigate:
          SUCCESS: SUCCESS
          FAILURE: GET_UPDATED_AT_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - id
    - created_at
    - updated_at

  results:
    - SUCCESS
    - GET_COLLABORATOR_DETAILS_FAILURE
    - GET_COLLABORATOR_ID_FAILURE
    - GET_CREATED_AT_FAILURE
    - GET_UPDATED_AT_FAILURE
#################################################### 
# This flow performs an REST API call in order to delete an Heroku application collaborator
# 
# Inputs: 
#   - username - the Heroku username - Example: 'someone@mailprovider.com'
#   - password - the Heroku used for authentication
#   - collaborator_email_or_id - the email or the id of the collaborator
#   - app_id_or_name - the name or the id of the Heroku application
#
# Outputs: 
#   - return_result - the response of the operation in case of success, the error message otherwise 
#   - error_message - return_result if statusCode is not '200' 
#   - return_code - '0' if success, '-1' otherwise 
#   - status_code - the code returned by the operation 
####################################################

namespace: io.cloudslang.paas.heroku.collaborators

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: delete_application_collaborator
  inputs:
    - username
    - password
    - collaborator_email_or_id
    - app_id_or_name

  workflow:
    - delete_app_collaborator:
        do:
          rest.http_client_delete:
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

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
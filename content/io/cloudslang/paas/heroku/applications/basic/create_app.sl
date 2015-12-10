#################################################### 
# This flow performs an REST API call in order to create an HEROKU application 
# 
# Inputs: 
#   - username - the HEROKU username - Example: 'someone@mailprovider.com' 
#   - password - the HEROKU used for authentication
#   - json_body - optional - the json used to create the HEROKU application
#
# Note : the json needs to be like : 
# {
#   "name": "app-name"
# } 
#   Note : if there is not a JSON, the name will be generate by HEROKU
#
# Outputs: 
#   - return_result - the response of the operation in case of success, the error message otherwise 
#   - error_message - return_result if statusCode is not '200' 
#   - return_code - '0' if success, '-1' otherwise 
#   - status_code - the code returned by the operation 
#
# Note : Use the operation json/createJsonSimple.sl in order to create the json_body
#        And use the operation json/analyseJsonResponse.sl in order to analyse the output of this operation !
#
#
#################################################### 
namespace: io.cloudslang.paas.heroku.applications.basic

imports:
  imports_operations: io.cloudslang.base.network.rest

flow:
  name: create_app
  inputs:
    - username
    - password
    - json_body:
        default: "{}"
        required: false
  workflow:
    - create_app:
        do:
          imports_operations.http_client_action:
            - url: "https://api.heroku.com/apps"
            - method: "POST"
            - username: ${username}
            - password: ${password}
            - contentType: "application/json"
            - headers: "Accept:application/vnd.heroku+json; version=3"
            - body: ${json_body}
            - validHttpStatusCodes: ${ range(200, 600) }
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
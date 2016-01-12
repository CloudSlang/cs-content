#################################################### 
# This flow performs an REST API call in order to create/add a new domain on a specified application
# 
# Inputs: 
#   - username - the Heroku username - Example: 'someone@mailprovider.com'
#   - password - the Heroku used for authentication
#   - app_id_or_name - the name or the id of the Heroku application to create a domain for
#   - hostname - full hostname of the new domain to be created - Example: 'subdomain.example.com'
#
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise 
#   - error_message - return_result if statusCode is not '201'
#   - return_code - '0' if success, '-1' otherwise 
#   - status_code - the code returned by the operation
#   - id - the id of the created domain - Example: '4517af43-3564-4c74-b0d0-da9344ee32c1'
#   - created_at - the exact time when the domain was created - Example: '2016-01-04T14:49:53Z'
#
# Results:
#   - SUCCESS - the new domain was successfully created/added
#   - INSERT_HOSTNAME_VALUE_FAILURE - insert 'hostname' key:value pair in a empty JSON step failed
#   - CREATE_DOMAIN_FAILURE - the create Heroku application domain REST API call failed
#   - GET_ID_FAILURE - the id of the newly created domain could not be retrieved from the create REST API call response
#   - GET_CREATED_AT_FAILURE - the time when the newly domain was created could not be retrieved from the create REST API
#                              call response
####################################################
namespace: io.cloudslang.paas.heroku.domains

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json

flow:
  name: create_domain
  inputs:
    - username
    - password
    - app_id_or_name
    - hostname

  workflow:
    - insert_hostname_value:
        do:
          json.add_value:
            - json_input: "{}"
            - json_path: ['hostname']
            - value: ${hostname}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: create_domain
          FAILURE: INSERT_HOSTNAME_VALUE_FAILURE

    - create_domain:
        do:
          rest.http_client_post:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name +'/domains'}
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
          SUCCESS: get_id
          FAILURE: CREATE_DOMAIN_FAILURE

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
    - INSERT_HOSTNAME_VALUE_FAILURE
    - CREATE_DOMAIN_FAILURE
    - GET_ID_FAILURE
    - GET_CREATED_AT_FAILURE
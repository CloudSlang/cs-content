####################################################
#!!
#! @description: Performs a REST API call to get the details of a specified domain.
#! @input username: Heroku username
#!                  example: 'someone@mailprovider.com'
#! @input password: Heroku password used for authentication
#! @input app_id_or_name: ID or name of the Heroku application on which domain resides
#! @input domain_id_or_hostname: ID or hostname of domain to retrieve the details for
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#! @output id: ID of the domain; useful when <domain_id_or_hostname> is a name
#! @output created_at: time when domain was created/added
#!                     example: '2016-01-04T14:49:53Z'
#! @output updated_at: time when the domain was last time updated
#!                     example: '2016-01-04T14:49:53Z'
#! @result SUCCESS: domain details were successfully retrieved
#! @result GET_DOMAIN_DETAILS_FAILURE: domain details could not be retrieved
#! @result GET_ID_FAILURE: domain ID could not be retrieved from GET REST API call response
#! @result GET_CREATED_AT_FAILURE: created_at domain time could not be retrieved from GET REST API call response
#! @result GET_UPDATED_AT_FAILURE: updated_at domain time could not be retrieved from GET REST API call response
#!!#
####################################################
namespace: io.cloudslang.cloud.heroku.domains

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: get_domain_details
  inputs:
    - username
    - password:
        sensitive: true
    - app_id_or_name
    - domain_id_or_hostname

  workflow:
    - get_domain_details:
        do:
          rest.http_client_get:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name +'/domains/' + domain_id_or_hostname}
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
          - FAILURE: GET_DOMAIN_DETAILS_FAILURE

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
          - SUCCESS: get_updated_at
          - FAILURE: GET_CREATED_AT_FAILURE

    - get_updated_at:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['updated_at']
        publish:
          - updated_at: ${value}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_UPDATED_AT_FAILURE

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
    - GET_DOMAIN_DETAILS_FAILURE
    - GET_ID_FAILURE
    - GET_CREATED_AT_FAILURE
    - GET_UPDATED_AT_FAILURE

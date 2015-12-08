# Created by Florian TEISSEDRE - florian.teissedre@hpe.com

namespace: io.cloudslang.heroku.domains

imports:
  heroku_operations: io.cloudslang.heroku.domains
  json_operations: io.cloudslang.heroku.json

flow:
  name: test_details_app_domain
  inputs:
    - username
    - password
    - app_name_or_id
    - domain_hostname_or_id
  workflow:
    - details_app_domains:
        do:
          heroku_operations.details_app_domain:
            - username
            - password
            - app_name_or_id
            - domain_hostname_or_id
        publish:
          - http_result: ${return_result}
        navigate:
          SUCCESS: analyse_response
          FAILURE: HTTP_ERROR

    - analyse_response:
        do:
          json_operations.analyseJsonResponse:
            - json_response: ${http_result}
        publish:
          - returnResult
          - idTypeResult
        navigate:
          SUCCESS: SUCCESS
          UNAUTHORIZED: UNAUTHORIZED
          NOT_FOUND: NOT_FOUND
          INVALID_PARAMS: INVALID_PARAMS
          BAD_REQUEST: BAD_REQUEST
          VERIFICATION_REQUIRED: VERIFICATION_REQUIRED
          FAILURE: JSON_ANALYSE_ERROR


  results:
    - SUCCESS : ${response_type == '0'}
    - FAILURE 
    - HTTP_ERROR
    - JSON_ANALYSE_ERROR
    - UNAUTHORIZED
    - NOT_FOUND
    - INVALID_PARAMS
    - BAD_REQUEST 
    - VERIFICATION_REQUIRED
# Created by Florian TEISSEDRE - florian.teissedre@hpe.com

namespace: io.cloudslang.heroku.addons

imports:
  heroku_operations: io.cloudslang.heroku.addons
  json_operations: io.cloudslang.heroku.json

flow:
  name: test_list_all_account_addons
  inputs:
    - username
    - password
  workflow:
    - account_all_addons:
        do:
          heroku_operations.list_all_account_addons:
            - username
            - password
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
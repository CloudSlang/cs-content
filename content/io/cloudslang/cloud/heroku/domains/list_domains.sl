####################################################
#!!
#! @description: Performs a REST API call to list all existing domains associated with a specified application.
#! @input username: Heroku username
#!                  example: 'someone@mailprovider.com'
#! @input password: Heroku password used for authentication
#! @input app_id_or_name: ID or name of the Heroku application that domains are associated with
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#!!#
####################################################

namespace: io.cloudslang.cloud.heroku.domains

imports:
  rest: io.cloudslang.base.http

flow:
  name: list_domains
  inputs:
    - username
    - password:
        sensitive: true
    - app_id_or_name

  workflow:
    - list_domains:
        do:
          rest.http_client_get:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name +'/domains'}
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

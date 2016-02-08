#################################################### 
#!!
#! @description: This flow performs an REST API call in order to list existing SSH keys of the user
#! @input username: the Heroku username - Example: 'someone@mailprovider.com'
#! @input password: the HerokuU used for authentication
#! @output return_result: the response of the operation in case of success, the error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: the code returned by the operation
#!!#
####################################################

namespace: io.cloudslang.paas.heroku.keys

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: list_keys
  inputs:
    - username
    - password

  workflow:
    - list_keys:
        do:
          rest.http_client_get:
            - url: "https://api.heroku.com/account/keys"
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
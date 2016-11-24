#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs a REST API call to list all existing Heroku add-ons for the given application.
#!
#! @input username: Heroku username
#!                  example: 'someone@mailprovider.com'
#! @input password: Heroku password used for authentication
#! @input app_name_or_id: name or the id of Heroku application
#!
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#!
#! @result SUCCESS: Heroku application add-ons retrieved successfully
#! @result FAILURE: there was an error while trying to retrieve Heroku application add-ons
#!!#
########################################################################################################################

namespace: io.cloudslang.heroku.addons

imports:
  rest: io.cloudslang.base.http

flow:
  name: list_addons_for_application

  inputs:
    - username
    - password:
        sensitive: true
    - app_name_or_id

  workflow:
    - list_addons_for_application:
        do:
          rest.http_client_get:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name + '/addons'}
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

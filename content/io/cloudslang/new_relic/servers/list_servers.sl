#   (c) Copyright 2016 Hewlett Packard Enterprise Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves a paginated list of the Servers associated with your New Relic account.
#! @input endpoint: New Relic servers API endpoint
#! @input api_key: the New Relic REST API key
#! @input filter_name:
#! @input filter_host:
#! @input filter_ids:
#! @input filter_labels:
#! @input page:
#! @input proxy_host: optional - proxy server used to access web site
#! @input proxy_port: optional - proxy server port
#! @input proxy_username: optional - username used when connecting to proxy
#! @input proxy_password: optional - proxy server password associated with <proxy_username> input value
#! @output return_result: response of operation
#! @output status_code: normal status code is '200'
#! @output return_code: if return_code == -1 then there was an error
#! @output error_message: return_result if return_code ==: 1 or status_code != '200'
#! @result SUCCESS: operation succeeded (return_code != '-1' and status_code == '200')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.new_relic.servers

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: list_servers
  inputs:
#!    - api_key

  workflow:
    - list_servers:
        do:
          rest.http_client_get:
            - url: "https://api.newrelic.com/v2/servers.json"
            - proxy_host: "proxy.houston.hp.com"
            - proxy_port: "8080"
            - headers: "X-Api-Key:a5472ddfe65f1373cf3088bb8b1045b7567caa73ff0a455"
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
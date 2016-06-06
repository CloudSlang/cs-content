#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Retrieves information about all droplets in a DigitalOcean account.
#! @input token: personal access token for DigitalOcean API
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @input proxy_username: optional - user name used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input connect_timeout: optional - time in seconds to wait for a connection to be established (0 represents infinite value)
#! @input socket_timeout: optional - time in seconds to wait for data to be retrieved (0 represents infinite value)
#! @output response: raw response of the API call
#! @output droplets: list of droplet objects - JSON types (object, array) are represented as Python objects
#!                   information can be retrieved in Python style - Example: droplet['name']
#!!#
########################################################################################################
namespace: io.cloudslang.cloud.digital_ocean.v2.droplets

imports:
  rest: io.cloudslang.base.http
  strings: io.cloudslang.base.strings
  json: io.cloudslang.base.json

flow:
  name: list_all_droplets

  inputs:
    - token:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false

  workflow:
    - execute_get_request:
        do:
          rest.http_client_get:
            - url: ${'https://api.digitalocean.com/v2/droplets'}
            - auth_type: 'anonymous'
            - headers: "${'Authorization: Bearer ' + token}"
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - content_type: 'application/json'
            - connect_timeout
            - socket_timeout
        publish:
          - response: ${return_result}
          - status_code

    - check_result:
        do:
          strings.string_equals:
            - first_string: '200'
            - second_string: ${str(status_code)}

    - extract_droplets_information:
        do:
          json.get_value:
            - json_input: ${ response }
            - json_path: ['droplets']
        publish:
          - droplets: ${value}
  outputs:
    - response
    - droplets

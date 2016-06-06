#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Deletes a DigitalOcean droplet based on its ID.
#! @input token: personal access token for DigitalOcean API
#! @input droplet_id: ID of the droplet as a string value
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @input proxy_username: optional - user name used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input connect_timeout: optional - time in seconds to wait for a connection to be established (0 represents infinite value)
#! @input socket_timeout: optional - time in seconds to wait for data to be retrieved (0 represents infinite value)
#! @output response: raw response of the API call
#!!#
########################################################################################################
namespace: io.cloudslang.cloud.digital_ocean.v2.droplets

imports:
  rest: io.cloudslang.base.http
  strings: io.cloudslang.base.strings

flow:
  name: delete_droplet

  inputs:
    - token:
        sensitive: true
    - droplet_id
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
    - execute_delete_request:
        do:
          rest.http_client_delete:
            - url: ${'https://api.digitalocean.com/v2/droplets/' + droplet_id}
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
            - first_string: '204'
            - second_string: ${str(status_code)}
  outputs:
    - response

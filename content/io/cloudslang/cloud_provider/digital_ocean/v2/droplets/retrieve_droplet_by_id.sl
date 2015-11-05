#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
# Retrieves information about an existing droplet.
#
# Inputs:
#   - droplet_id - id of the droplet as string or number
#   - token - personal access token for DigitalOcean API
#   - proxy_host - optional - proxy server used to access the web site
#   - proxy_port - optional - proxy server port
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxyUsername> input value
#   - connect_timeout - optional - time to wait for a connection to be established, in seconds (0 represents infinite value)
#   - socket_timeout - optional - time to wait for data to be retrieved, in seconds (0 represents infinite value)
#
# Outputs:
#   - response - raw response of the API call
#   - status_code - status code of the underlying GET request
#   - droplet - droplet object in case of SUCCESS - JSON types (object, array) are represented as Python objects
#             - information can be retrieved in Python style - e.g. droplet['name']
#             - None in case of FAILURE
#   - droplet_status - status of the droplet is case of SUCCESS, empty in case of FAILURE
########################################################################################################
namespace: io.cloudslang.cloud_provider.digital_ocean.v2.droplets

imports:
  rest: io.cloudslang.base.network.rest
  strings: io.cloudslang.base.strings
  json: io.cloudslang.base.json

flow:
  name: retrieve_droplet_by_id

  inputs:
    - droplet_id
    - token
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false

  workflow:
    - execute_get_request:
        do:
          rest.http_client_get:
            - url: "'https://api.digitalocean.com/v2/droplets/' + str(droplet_id)"
            - auth_type: "'anonymous'"
            - headers: "'Authorization: Bearer ' + token"
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - content_type: "'application/json'"
            - connect_timeout
            - socket_timeout
        publish:
          - response: return_result
          - status_code

    - check_result:
        do:
          strings.string_equals:
            - first_string: "'200'"
            - second_string: str(status_code)

    - extract_droplets_information:
        do:
          json.get_value:
            - json_input: response
            - key_list: ["'droplet'"]
        publish:
          - droplet: value
  outputs:
    - response
    - status_code
    - droplet
    - droplet_status: droplet['status'] if status_code == '200' else ''

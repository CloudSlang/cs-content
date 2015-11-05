#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
# This flow creates a DigitalOcean droplet.
#
# Inputs:
#   - name - human-readable string you wish to use when displaying the Droplet name
#   - region - optional - unique slug identifier for the region that you wish to deploy in - Default: ams3
#   - size - unique slug identifier for the size that you wish to select for this Droplet - Default: 512mb
#   - image - ID or slug identifier of the base image for your droplet
#   - ssh_keys - optional - array containing the IDs of the SSH keys
#                           that you wish to embed in the Droplet's root account upon creation
#                         - Default: None
#   - backups - optional - boolean indicating whether automated backups should be enabled for the Droplet.
#                          Automated backups can only be enabled when the Droplet is created
#                        - Default: false
#   - ipv6 - optional - boolean indicating whether IPv6 is enabled on the Droplet - Default: false
#   - private_networking - optional - boolean indicating whether private networking is enabled for the Droplet
#                        - Default: false
#   - user_data - optional - string of the desired User Data for the Droplet. Double quotes (") need to escaped.
#               - Default: None
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
#   - droplet_id - ID of the created droplet in case of success, empty in case of failure
########################################################################################################
namespace: io.cloudslang.cloud_provider.digital_ocean.v2.droplets

imports:
  rest: io.cloudslang.base.network.rest
  strings: io.cloudslang.base.strings
  json: io.cloudslang.base.json

flow:
  name: create_droplet

  inputs:
    - name
    - region: "'ams3'"
    - size: "'512mb'"
    - image
    - ssh_keys:
        default: None
        required: false
    - backups: false
    - ipv6: false
    - private_networking: false
    - user_data:
        default: None
        required: false
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
    - ssh_keys_formatted:
        default: str(ssh_keys) if ssh_keys else 'null'
        overridable: false
    - user_data_formatted:
        default: user_data if user_data else 'null'
        overridable: false

  workflow:
    - execute_post_request:
        do:
          rest.http_client_post:
            - url: "'https://api.digitalocean.com/v2/droplets'"
            - auth_type: "'anonymous'"
            - headers: "'Authorization: Bearer ' + token"
            - body: >
                '{ ' +
                '"name": "' + name + '", ' +
                '"region": "' + region + '", ' +
                '"size": "' + size + '", ' +
                '"image": "' + str(image) + '", ' +
                '"ssh_keys": ' + ssh_keys_formatted + ', ' +
                '"backups": ' + str(backups).lower() + ', ' +
                '"ipv6": ' + str(ipv6).lower() + ', ' +
                '"private_networking": ' +  str(private_networking).lower() + ', ' +
                '"user_data": ' + user_data_formatted +
                ' }'
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
            - first_string: "'202'"
            - second_string: str(status_code)

    - extract_droplet_id:
        do:
          json.get_value:
            - json_input: response
            - key_list: ["'droplet'", "'id'"]
        publish:
          - droplet_id: value
  outputs:
    - response
    - droplet_id: droplet_id if droplet_id else ''

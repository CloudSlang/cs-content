#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Main flow to authenicate and login to HP Cloud
#
# Inputs:
#   - username - HP Cloud account username 
#   - password - HP Cloud account password 
#   - tenant_name - name of HP Cloud tenant e.g. 'bob.smith@hp.com-tenant1'
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - token - authentication token, used for all other HP Cloud flows and operations
#   - tenant_id - tenant id, used for many other HP Cloud flows and operations
#   - return_result - JSON response
#   - error_message - any errors
# Results:
#   - SUCCESS - flow succeeded, login OK
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

imports:
  json: io.cloudslang.base.json

flow:
  name: get_authentication_flow
  
  inputs:
    - username
    - password
    - tenant_name
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - get_token:
        do:
          get_authentication:
            - username
            - password
            - tenant_name
            - region
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - return_code
          - error_message

    - get_authentication_token:
        do:
          json.get_value_from_json:
            - json_input: return_result
            - key_list: ["'access'", "'token'", "'id'"]
        publish:
          - token: value
          - error_message

    - get_tenant_id:
        do:
          json.get_value_from_json:
            - json_input: return_result
            - key_list: ["'access'", "'token'", "'tenant'", "'id'"]
        publish:
          - tenant_id: value
          - error_message

  outputs:
    - return_result
    - error_message
    - token
    - tenant_id

#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Main flow to authenicate and login to HP Cloud.
#! @input username: HP Cloud account username
#! @input password: HP Cloud account password
#! @input tenant_name: name of HP Cloud tenant - Example: 'bob.smith@hp.com-tenant1'
#! @input region: HP Cloud region; 'a' or 'b'  (US West or US East)
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @output return_result: JSON response
#! @output error_message: any errors
#! @output token: authentication token, used for all other HP Cloud flows and operations
#! @output tenant_id: tenant ID, used for many other HP Cloud flows and operations
#! @result SUCCESS: flow succeeded, login OK
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.hp_cloud

imports:
  hp_cloud: io.cloudslang.cloud.hp_cloud
  json: io.cloudslang.base.json

flow:
  name: get_authentication_flow

  inputs:
    - username
    - password:
        sensitive: true
    - tenant_name
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - get_token:
        do:
          hp_cloud.get_authentication:
            - username
            - password
            - tenant_name
            - region
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - error_message
          - status_code

    - get_authentication_token:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ["access", "token", "id"]
        publish:
          - token: ${value}
          - error_message

    - get_tenant_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ["access", "token", "tenant", "id"]
        publish:
          - tenant_id: ${value}
          - error_message

  outputs:
    - return_result
    - error_message
    - token:
        value: ${token}
        sensitive: true
    - tenant_id

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
#   - tenant_name - Name of HP Cloud tenant e.g. 'bob.smith@hp.com-tenant1'
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - token - Authentication token, used for all other HP Cloud flows and operations
#   - tenant - Tenant id, used for many other HP Cloud flows and operations
#   - return_result - JSON response
#   - error_message - Any errors
# Results:
#   - SUCCESS - flow succeeded, login OK
#   - FAILURE - Logon failed
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

imports:
 openstack_utils: io.cloudslang.openstack.utils
 print: io.cloudslang.base.print
 hpcloud: io.cloudslang.cloud_provider.hp_cloud

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
          hpcloud.get_authentication:
            - username
            - password
            - tenant_name
            - region
            - proxy_host:
                required: false
            - proxy_port:
                required: false
        publish:
          - return_result
          - return_code
          - error_message

    - parse_authentication:
        do:
          openstack_utils.parse_authentication:
            - json_authentication_response: return_result
        publish:
          - token
          - tenant
          - error_message

  outputs:
    - token
    - tenant
    - return_result
    - error_message

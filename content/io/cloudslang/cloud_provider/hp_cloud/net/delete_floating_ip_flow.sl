#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Main flow to call to release a floating IP 
#
# Inputs:
#   - ip_address - floating IP address to be released
#   - token - auth token obtained by get_authenication_flow
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - status_code - normal status code is 202
# Results:
#   - SUCCESS - operation succeeded
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud.net

imports:
  utils: io.cloudslang.cloud_provider.hp_cloud.utils

flow:
  name: delete_floating_ip_flow
  inputs:
    - ip_address
    - token
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - list_ipadresses:
        do:
          list_all_floatingips:
            - token
            - region
            - proxy_host: 
                required: false
            - proxy_port: 
                required: false
        publish:
          - return_result
          - status_code

    - get_floatingip_id:
        do:
          utils.get_floatingip_id:
            - json_ip_list: return_result
            - ip_address
        publish:
          - ip_id

    - release_ip:
        do:
          delete_floating_ip:
            - ip_id
            - token
            - region
            - proxy_host: 
                required: false
            - proxy_port: 
                required: false          
        publish:
          - status_code

  outputs:
    - status_code
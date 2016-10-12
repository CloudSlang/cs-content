#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Main flow to call to release a floating IP.
#! @input ip_address: floating IP address to be released
#! @input token: auth token obtained by get_authenication_flow
#! @input region: HP Cloud region; 'a' or 'b'  (US West or US East)
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @output status_code: normal status code is 202
#! @result SUCCESS: operation succeeded
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.hp_cloud.net

imports:
  utils: io.cloudslang.cloud.hp_cloud.utils
  net: io.cloudslang.cloud.hp_cloud.net

flow:
  name: delete_floating_ip_flow
  inputs:
    - ip_address
    - token:
        sensitive: true
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - list_ipadresses:
        do:
          net.list_all_floating_ips:
            - token
            - region
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - status_code

    - get_floating_ip_id:
        do:
          utils.get_floating_ip_id:
            - json_ip_list: ${return_result}
            - ip_address
        publish:
          - ip_id

    - release_ip:
        do:
          net.delete_floating_ip:
            - ip_id
            - token
            - region
            - proxy_host
            - proxy_port
        publish:
          - status_code

  outputs:
    - status_code

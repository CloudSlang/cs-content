#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Main flow to call to obtain a floating IP.
#! @input token: auth token obtained by get_authenication_flow
#! @input region: HP Cloud region; 'a' or 'b'  (US West or US East)
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @output return_result: response of the operation
#! @output status_code: normal status code is 202
#! @output ip_address: IP address created
#! @result SUCCESS: operation succeeded
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.hp_cloud.net

imports:
  utils: io.cloudslang.cloud.hp_cloud.utils
  print: io.cloudslang.base.print
  json: io.cloudslang.base.json
  net: io.cloudslang.cloud.hp_cloud.net

flow:
  name: create_floating_ip_flow
  inputs:
    - token:
        sensitive: true
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - list_networks:
        do:
          net.list_all_networks:
            - token
            - region
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - status_code

    - get_external_id:
        do:
          utils.get_external_net_id:
            - json_network_list: ${return_result}
        publish:
          - ext_network_id

    - allocate_floating_ip:
        do:
          net.create_floating_ip:
            - ext_network_id
            - token
            - region
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - status_code

    - get_ip_result:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ["floatingip", "floating_ip_address"]
        publish:
          - ip_address: ${value}

    - on_failure:
      - ip_error:
          do:
            print.print_text:
              - text: "${'! ERROR ALLOCATING IP (' + status_code + ') : ' + return_result}"

  outputs:
    - return_result
    - status_code
    - ip_address

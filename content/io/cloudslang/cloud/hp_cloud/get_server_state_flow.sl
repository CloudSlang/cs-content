#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Flow to poll HP Cloud API until server is ready and in ACTIVE state.
#!               Possible server states = ACTIVE, BUILD, REBUILD, STOPPED, MIGRATING, RESIZING, PAUSED, SUSPENDED, RESCUE, ERROR, DELETED
#! @input server_id: ID of server
#! @input tenant: tenant ID obtained by get_authenication_flow
#! @input token: auth token obtained by get_authenication_flow
#! @input region: HP Cloud region; 'a' or 'b'  (US West or US East)
#! @input delay: optional - pause in seconds before checking (when called in loop to throttle API calls) - Default: 0
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @output server_status: status value string of the server
#! @result FAILURE: failure for some reason
#! @result ACTIVE: server is ACTIVE
#! @result NOT_ACTIVE: server is state other than ACTIVE
#!!#
####################################################

namespace: io.cloudslang.cloud.hp_cloud

imports:
  hp_cloud: io.cloudslang.cloud.hp_cloud
  print: io.cloudslang.base.print
  json: io.cloudslang.base.json
  base_utils: io.cloudslang.base.utils
  strings: io.cloudslang.base.strings

flow:
  name: get_server_state_flow
  inputs:
    - server_id
    - tenant
    - token:
        sensitive: true
    - region
    - delay:
        default: 0
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - wait:
        do:
          base_utils.sleep:
            - seconds: ${int(delay)}

    - get_details:
        do:
          hp_cloud.get_server_details:
            - server_id
            - tenant
            - token
            - region
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - status_code
        navigate:
          - SUCCESS: extract_status
          - FAILURE: failed

    - extract_status:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ["server", "status"]
        publish:
          - server_status: ${value}
        navigate:
          - SUCCESS: check_active
          - FAILURE: failed

    - check_active:
        do:
          strings.string_equals:
            - first_string: ${server_status}
            - second_string: 'ACTIVE'
        navigate:
          - SUCCESS: ACTIVE
          - FAILURE: NOT_ACTIVE

    - failed:
          do:
            print.print_text:
              - text: "${'! ERROR GETTING SERVER INFO: \\nStatus:' + status_code + '\\n' + return_result}"
          navigate:
            - SUCCESS: FAILURE

  outputs:
    - server_status

  results:
    - FAILURE
    - ACTIVE
    - NOT_ACTIVE

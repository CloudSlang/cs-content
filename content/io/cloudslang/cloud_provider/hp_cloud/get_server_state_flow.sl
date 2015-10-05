####################################################
#
# OpenStack content for HP Helion Public Cloud
# Modified from io.cloudslang.openstack (v0.8) content
#
# Ben Coleman, Sept 2015
# v0.1
#
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

imports:
  print: io.cloudslang.base.print
  json: io.cloudslang.base.json
  base_utils: io.cloudslang.base.utils
  strings: io.cloudslang.base.strings

flow:
  name: get_server_state_flow
  inputs:
    - token
    - host
    - port
    - server_id
    - tenant
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
            - seconds: delay

    - get_details:
        do:
          get_server_details:
            - host
            - port
            - server_id
            - tenant
            - token    
            - proxy_host: 
                required: false
            - proxy_port: 
                required: false 
        publish:
          - return_result
          - status_code
        navigate:
          SUCCESS: extract_status
          FAILURE: failed          

    - extract_status:
        do:
          json.get_value_from_json:
            - json_input: return_result
            - key_list: ["'server'", "'status'"]
        publish:
          - server_status: value
        navigate:
          SUCCESS: check_active
          FAILURE: failed          

    - check_active:
        do:
          strings.string_equals:
            - first_string: server_status
            - second_string: "'ACTIVE'"
        navigate:
          SUCCESS: ACTIVE
          FAILURE: NOTACTIVE

    - failed:
          do:
            print.print_text:
              - text: "'! ERROR GETTING SERVER INFO: \\nStatus:' + status_code + '\\n' + return_result"
          navigate:
            SUCCESS: FAILURE
  outputs:
    - server_status

  results:
    - FAILURE
    - ACTIVE
    - NOTACTIVE

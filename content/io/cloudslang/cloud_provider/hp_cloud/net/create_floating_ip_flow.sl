####################################################
#
# OpenStack content for HP Helion Public Cloud
# Modified from io.cloudslang.openstack (v0.8) content
#
# Ben Coleman, Sept 2015
# v0.1
#
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud.net

imports:
  utils: io.cloudslang.cloud_provider.hp_cloud.utils
  print: io.cloudslang.base.print
  json: io.cloudslang.base.json
  
flow:
  name: create_floating_ip_flow
  inputs:
    - token
    - host
    - port
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - list_networks:
        do:
          list_all_networks:
            - token
            - host
            - port
            - proxy_host: 
                required: false
            - proxy_port: 
                required: false
        publish:
          - return_result
          - status_code

    - get_external_id:
        do:
          utils.get_external_net_id:
            - json_str: return_result
        publish:
          - ext_network_id

    - allocate_floating_ip:
        do:
          create_floating_ip:
            - ext_network_id
            - token
            - host
            - port
            - proxy_host: 
                required: false
            - proxy_port: 
                required: false          
        publish:
          - return_result
          - status_code

    - get_ip_result:
        do:
          json.get_value_from_json:
            - json_input: return_result
            - key_list: ["'floatingip'", "'floating_ip_address'"]
        publish:
          - ip_address: value

    - on_failure:
      - IP_ERROR:
          do:
            print.print_text:
              - text: "'! ERROR ALLOCATING IP !  Code:' + status_code + ' :: ' + return_result" 

  outputs:
    - return_result
    - status_code
    - ip_address
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
  utils: io.cloudslang.cloud_provider.hp_cloud.utils
  net: io.cloudslang.cloud_provider.hp_cloud.net
  print: io.cloudslang.base.print
  base_utils: io.cloudslang.base.utils
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: create_server_flow
  inputs:
    - identity_host
    - compute_host
    - network_host
    - identity_port:
        default: "'35357'"
    - compute_port:
        default: "'443'"
    - network_port:
        default: "'443'"
    - network_id:
        required: false
    - server_name
    - img_ref
    - flavor_ref
    - keypair
    - assign_floating:
        default: False
    - username
    - password
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - authentication:
        do:
          get_authentication_flow:
            - host: identity_host
            - identity_port
            - username
            - password
            - tenant_name
            - proxy_host: 
                required: false
            - proxy_port: 
                required: false
        publish:
          - token
          - tenant
          - return_result
          - error_message    

    - create_server:
        do:
          create_server:
            - host: compute_host
            - port: compute_port
            - token
            - tenant
            - img_ref
            - flavor_ref
            - keypair
            - server_name
            - proxy_host: 
                required: false
            - proxy_port: 
                required: false         
        publish:
          - return_result

    - get_server_id:
        do:
          json.get_value_from_json:
            - json_input: return_result
            - key_list: ["'server'", "'id'"]
        publish:
          - server_id: value

    - print_new_server_id:
        do:
          print.print_text:
            - text: "'### New server created: '+server_id"

    - poll_server_active:
        loop:
          for: loop_counter in range(0,20)
          do:
            get_server_state_flow:
              - host: compute_host
              - port: compute_port
              - delay: 10
              - token
              - tenant
              - server_id  
              - proxy_host: 
                  required: false
              - proxy_port: 
                  required: false
          break:
            - ACTIVE
            - FAILURE
        navigate:
          ACTIVE: check_assign_floating
          NOTACTIVE: FAILURE 
          FAILURE: FAILURE         

    - check_assign_floating:
        do:
          base_utils.check_bool:
            - bool_value: assign_floating
        navigate:
          SUCCESS: allocate_new_ip
          FAILURE: done

    - allocate_new_ip:
        do:
          net.create_floating_ip_flow:
            - host: network_host
            - port: network_port
            - token
            - proxy_host: 
                required: false
            - proxy_port: 
                required: false            
        publish:
          - return_result
          - ip_address

    - print_new_ip:
        do:
          print.print_text:
            - text: "'### Got a floating IP: '+ip_address"

    - assign_ip:
        do:
          net.add_ip_to_server:
            - host: compute_host
            - port: compute_port
            - tenant: tenant_name
            - token
            - server_id
            - ip_address
            - proxy_host: 
                required: false
            - proxy_port: 
                required: false          
        publish:
          - return_result

    - done:
        do:
          print.print_text:
            - text: "'### New server ('+server_name+') is ready'"

    - on_failure:
      - FLOW_ERROR:
          do:
            print.print_text:
              - text: "'! Create Server Flow Error ! ' + return_result" 
  outputs:
    - return_result
    - ip_address
    - server_id

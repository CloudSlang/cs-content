####################################################
#
# OpenStack content for HP Helion Public Cloud
# Modified from io.cloudslang.openstack (v0.8) content
#
# Ben Coleman, Oct 2015
# v0.1
#
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

imports:
  print: io.cloudslang.base.print
  base_utils: io.cloudslang.base.utils
  net: io.cloudslang.cloud_provider.hp_cloud.net  

flow:
  name: delete_server_flow
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
    - username
    - password
    - tenant_name
    - server_id
    - ip_address:  
        required: false
    - release_ip_address:
        default: True    
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

    - delete_server:
        do:
          delete_server:
            - host: compute_host
            - compute_port
            - token
            - tenant
            - server_id
            - proxy_host:
                required: false
            - proxy_port:
                required: false
        publish:
          - return_result
          - error_message

    - check_release_ip_address:
        do:
          base_utils.check_bool:
            - bool_value: release_ip_address
        navigate:
          SUCCESS: do_release_ip
          FAILURE: done

    - do_release_ip:
        do:
          net.delete_floating_ip_flow:
            - host: network_host
            - port: network_port
            - ip_address
            - token
            - proxy_host: 
                required: false
            - proxy_port: 
                required: false            

    - done:
        do:
          print.print_text:
            - text: "'### Server ('+server_id+') was removed'"
  outputs:
    - return_result
    - error_message
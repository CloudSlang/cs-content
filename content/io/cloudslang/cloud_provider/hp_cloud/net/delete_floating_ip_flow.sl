####################################################
#
# OpenStack content for HP Helion Public Cloud
# Modified from io.cloudslang.openstack (v0.8) content
#
# Ben Coleman, Oct 2015
# v0.1
#
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud.net

imports:
  utils: io.cloudslang.cloud_provider.hp_cloud.utils

flow:
  name: delete_floating_ip_flow
  inputs:
    - token
    - host
    - port
    - ip_address
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - list_ipadresses:
        do:
          list_all_floatingips:
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

    - get_floatingip_id:
        do:
          utils.get_floatingip_id:
            - json_str: return_result
            - ip_address
        publish:
          - ip_id

    - release_ip:
        do:
          delete_floating_ip:
            - ip_id
            - token
            - host
            - port
            - proxy_host: 
                required: false
            - proxy_port: 
                required: false          
        publish:
          - status_code

  outputs:
    - status_code
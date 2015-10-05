####################################################
#
# OpenStack content for HP Helion Public Cloud
# Modified from io.cloudslang.openstack (v0.8) content
#
# Ben Coleman, Oct 2015
# v0.1
#
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud.utils

operation:
  name: get_floatingip_id
  inputs:
    - json_str
    - ip_address
  action:
    python_script: |
      import json
      ip_id = ''
      decoded = json.loads(json_str)
      for ip in decoded['floatingips']:
         if(ip['floating_ip_address'] == ip_address):
            ip_id = ip['id']
            break

  outputs:
    - ip_id    

  results:
    - SUCCESS: 
    - FAILURE
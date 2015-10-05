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
  name: get_external_net_id  
  inputs:
    - json_str

  action:
    python_script: |
      import json
      ext_network_id = ''
      decoded = json.loads(json_str)
      for net in decoded['networks']:
         if(net['router:external']):
            ext_network_id = net['id']
            break

  outputs:
    - ext_network_id    

  results:
    - SUCCESS: 
    - FAILURE
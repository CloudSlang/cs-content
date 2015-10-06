#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Get the id of the one external network from a JSON list of networks 
#
# Inputs:
#   - json_network_list - Output of the list_all_networks operation
# Outputs:
#   - ext_network_id - Id of external network
# Results:
#   - SUCCESS - Found the external network id and returned it
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud.utils

operation:
  name: get_external_net_id  
  inputs:
    - json_network_list

  action:
    python_script: |
      import json
      ext_network_id = ''
      decoded = json.loads(json_network_list)
      for net in decoded['networks']:
         if(net['router:external']):
            ext_network_id = net['id']
            break

  outputs:
    - ext_network_id    

  results:
    - SUCCESS: "len(ext_network_id) > 0"
    - FAILURE
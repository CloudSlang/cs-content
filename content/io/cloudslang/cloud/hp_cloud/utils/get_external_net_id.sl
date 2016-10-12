#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Get the id of the one external network from a JSON list of networks.
#! @input json_network_list: output of the list_all_networks operation
#! @output ext_network_id: ID of external network
#! @result SUCCESS: found the external network ID and returned it
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.hp_cloud.utils

operation:
  name: get_external_net_id
  inputs:
    - json_network_list

  python_action:
    script: |
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
    - SUCCESS: ${len(ext_network_id) > 0}
    - FAILURE

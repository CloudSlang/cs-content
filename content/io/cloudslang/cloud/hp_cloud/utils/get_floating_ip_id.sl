#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Get the id of a specified IP address.
#! @input json_ip_list: output of the list_all_floating_ips operation
#! @input ip_address: IP address to get the ID for
#! @output ip_id: ID of IP address provided
#! @result SUCCESS: found the IP address ID and returned it
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.hp_cloud.utils

operation:
  name: get_floating_ip_id
  inputs:
    - json_ip_list
    - ip_address

  python_action:
    script: |
      import json
      ip_id = ''
      decoded = json.loads(json_ip_list)
      for ip in decoded['floatingips']:
         if(ip['floating_ip_address'] == ip_address):
            ip_id = ip['id']
            break

  outputs:
    - ip_id

  results:
    - SUCCESS: ${len(ip_id) > 0}
    - FAILURE

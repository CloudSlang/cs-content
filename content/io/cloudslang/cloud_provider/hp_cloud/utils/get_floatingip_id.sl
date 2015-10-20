#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Get the id of a specified IP address
#
# Inputs:
#   - json_ip_list - output of the list_all_floatingips operation
#   - ip_address - IP address we want the id for
# Outputs:
#   - ip_id - id of IP address provided
# Results:
#   - SUCCESS - found the IP address id and returned it
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud.utils

operation:
  name: get_floatingip_id
  inputs:
    - json_ip_list
    - ip_address

  action:
    python_script: |
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
    - SUCCESS: "len(ip_id) > 0"
    - FAILURE
#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Remove node and client from Chef
#
# Inputs:
#   - knife_host - Server with configured knife accessable via SSH, can be main Chef server
#   - knife_username - SSH username to access server with knife
#   - knife_password - optional - If using password auth
#   - knife_privkey - optional - SSH keyfile, if using keyfile auth  (local file that resides where flow is executing)
#   - node_name - Name of node in Chef to be deleted
# Outputs:
#   - knife_result - Filtered output of knife command
#   - raw_result - Full STDOUT
#   - standard_err - Any STDERR
# Results:
#   - SUCCESS - Node deleted OK
#   - FAILURE - Otherwise
####################################################

namespace: io.cloudslang.chef

flow:
  name: delete_node
  inputs:
    - node_name
    - knife_host
    - knife_username
    - knife_privkey:
        default: "''"
        required: false    
    - knife_password: 
        default: "''"
        required: false

  workflow:
    - remove_client:
        do:
          knife_command:
            - knife_cmd: "'client delete '+node_name+' -y'"  
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey   
        publish:
          - returnResult
          - standard_err
          - knife_result
          
    - remove_node:
        do:
          knife_command:
            - knife_cmd: "'node delete '+node_name+' -y'"  
            - knife_host
            - knife_username
            - knife_password: 
                required: false  
                default: knife_password
            - knife_privkey: 
                required: false  
                default: knife_privkey   
        publish:
          - returnResult
          - standard_err
          - knife_result

  outputs:
    - raw_result: returnResult
    - knife_result: knife_result
    - standard_err: standard_err

  results:
    - SUCCESS:
    - FAILURE

#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Run Chef knife command and return filtered result
#
# Inputs:
#   - knife_cmd - Knife command to run e.g. 'cookbook list'
#   - knife_host - Server with configured knife accessable via SSH, can be main Chef server
#   - knife_username - SSH username to access server with knife
#   - knife_password - optional - If using password auth
#   - knife_privkey - optional - SSH keyfile, if using keyfile auth  (local file that resides where flow is executing)
#   - knife_timeout - optional - Timeout in millsecs, default is 30 seconds
# Outputs:
#   - knife_result - Filtered output of knife command
#   - raw_result - Full STDOUT
#   - standard_err - Any STDERR
# Results:
#   - SUCCESS - Command successful
#   - FAILURE - Otherwise
####################################################

namespace: io.cloudslang.chef

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: knife_command
  inputs:
    - knife_cmd
    - knife_host
    - knife_username
    - knife_privkey:
        default: "''"
        required: false    
    - knife_password: 
        default: "''"
        required: false
    - knife_timeout:
        default: "'300000'"
        required: false
        
  workflow:
    - knife_cmd:
        do:
          ssh.ssh_command:
            - host: knife_host
            - username: knife_username
            - password: knife_password
            - privateKeyFile: knife_privkey  
            - command: "'echo [knife output];knife ' + knife_cmd"
            - timeout: knife_timeout
        publish:
          - returnResult
          - standard_err
          - return_code

  outputs:
    - raw_result: returnResult
    - knife_result: "standard_err + ' ' + returnResult.split('[knife output]')[1]"
    - standard_err: standard_err

  results:
    - SUCCESS: 
    - FAILURE: 

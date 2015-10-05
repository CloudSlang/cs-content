####################################################
# Chef content for CloudSlang
# Ben Coleman, Sept 2015, v1.0
####################################################
# Run Chef knife command and return filtered result
#
# Inputs:
#   - knife_host - Server with configured knife accessable via SSH, can be main Chef server
#   - knife_username - SSH username to access server with knife
#   - knife_password - optional - If using password auth
#   - knife_privkey - SSH keyfile (local file that resides where flow is executing)
#   - knife_cmd - Knife command to run e.g. 'cookbook list'
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
  print: io.cloudslang.base.print

flow:
  name: knife_command
  inputs:
    - knife_host
    - knife_username
    - knife_password: "''"
    - knife_privkey   # Note this is a local file that resides where flow is executing
    - knife_cmd
  workflow:
    - knife_cmd:
        do:
          ssh.ssh_command:
            - host: knife_host
            - username: knife_username
            - password: knife_password
            - privateKeyFile: knife_privkey
            - command: "'echo [knife output];knife ' + knife_cmd"
            - timeout: "'300000'"
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

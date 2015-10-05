####################################################
# Chef content for CloudSlang
# Ben Coleman, Sept 2015, v1.0
####################################################
# Remove node from Chef
#
# Inputs:
#   - knife_host - Server with configured knife accessable via SSH, can be main Chef server
#   - knife_username - SSH username to access server with knife
#   - knife_password - optional - If using password auth
#   - knife_privkey - SSH keyfile (local file that resides where flow is executing)
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
    - knife_host
    - knife_username
    - knife_password: "''"
    - knife_privkey   # Note this is a local file that resides where flow is executing
    - node_name
  workflow:
    - remove_client:
        do:
          knife_command:
            - knife_cmd: "'client delete '+node_name+' -y'"  
            - knife_host: knife_host
            - knife_username: knife_username
            - knife_privkey: knife_privkey     
            - knife_password: knife_password   
        publish:
          - returnResult
          - standard_err
          - knife_result
    - remove_node:
        do:
          knife_command:
            - knife_cmd: "'node delete '+node_name+' -y'"  
            - knife_host: knife_host
            - knife_username: knife_username
            - knife_privkey: knife_privkey     
            - knife_password: knife_password   
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

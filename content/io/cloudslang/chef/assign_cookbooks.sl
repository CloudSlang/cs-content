####################################################
# Chef content for CloudSlang
# Ben Coleman, Sept 2015, v1.0
####################################################
# Assigns one or more Chef cookbooks (comma seperated) to a node's run list
#
# Inputs:
#   - knife_host - Server with configured knife accessable via SSH, can be main Chef server
#   - knife_username - SSH username to access server with knife
#   - knife_password - optional - If using password auth
#   - knife_privkey - SSH keyfile (local file that resides where flow is executing)
# Outputs:
#   - knife_result - Filtered output of knife command
#   - raw_result - Full STDOUT
#   - standard_err - Any STDERR
# Results:
#   - SUCCESS - Cookbooks were added to the run list
#   - FAILURE - Otherwise
####################################################

namespace: io.cloudslang.chef

flow:
  name: assign_cookbooks
  inputs:
    - knife_host
    - knife_username
    - knife_password: "''"
    - knife_privkey   
    - cookbooks
    - node_name
  workflow:
    - add_to_run_list:
        do:
          knife_command:
            - knife_cmd: "'node run_list add '+node_name+' \\''+cookbooks+'\\''"  
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
    - SUCCESS
    - FAILURE

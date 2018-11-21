########################################################################################################################
#!!
#! @description: The configuration modifies the pg_hba.conf file
#!
#! @input	file_path: The full path to the PostgreSQL configuration file in the local machine to be updated
#! @input	allowed_hosts: A wildcard or a comma-separated list of hostnames or IPs (IPv4 or IPv6).
#! @input	allowed_users: A comma-separated list of PostgreSQL users. If no value is specified for this input, all users will have access to the server.
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
#!
#! @result SUCCESS: Postgresql configuration was modified successfully
#! @result FAILURE: There was an error modifying postgresql configuration
#!!#
########################################################################################################################
namespace: io.cloudslang.postgresql

operation:
  name: update_pg_hba_config

  inputs:
    - file_path:
        required: true
    - allowed_hosts:
        required: false
    - allowed_users:
        required: false
  java_action:
    gav: io.cloudslang.content:cs-cfg:0.0.1
    class_name: io.cloudslang.content.cfg.action.UpdatePgHbaConfigAction
    method_name: execute
  outputs:
     - returnCode
     - returnResult
     - stderr
     - exception
  results:
    - SUCCESS: ${ returnCode == '0' }
    - FAILURE
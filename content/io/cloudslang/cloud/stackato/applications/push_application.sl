namespace: io.cloudslang.cloud.stackato.applications

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: push_application
  inputs:
    - node
    - node_username
    - node_password
    - org_user
    - org_user_password
    - repo_name
    - app_name
    - app_source_path
#    - space_guid


  workflow:
    - authentication:
        do:
          ssh.ssh_flow:
            - host: ${node}
            - port: '22'
            - username: ${node_username}
            - password: ${node_password}
            - command: ${'/usr/bin/expect << EOF \nspawn stackato login ' + org_user +'\nexpect \"*Password:*\"\nsend ' + org_user_password +'\r\nexpect \"Successfully logged\"\nEOF\n\r'}
      publish:
        - return_result
        - standard_err
        - standard_out
        - return_code
        - command_return_code
    - clone_app_code:
        do:
          ssh.ssh_flow:
            - host: ${node}
            - port: '22'
            - username: ${node_username}
            - password: ${node_password}
            - command: ${'cd '+ app_source_path+ ' && git clone https://github.com/'+repo_name+'/'+app_name+'.git'}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code

    - push_app:
        do:
          ssh.ssh_flow:
            - host: ${node}
            - port: '22'
            - username: ${node_username}
            - password: ${node_password}
            - command: ${'cd '+ app_source_path+'/'+app_name+' && stackato push -n'}
            - timeout: '99999'
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
  outputs:
    - return_result
    - standard_err
    - standard_out
    - return_code
    - command_return_code

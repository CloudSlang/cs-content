# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs several linux commands in order to deploy Tomcat application on Ubuntu 14.04 server
#
# Inputs:
#   - host - hostname or IP address
#   - root_password - the root password
#   - user_password - optional - the Tomcat user password - Default: ''
#   - download_url - the URL address where the content to be downloaded is
#                  - Default: 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.61/bin/apache-tomcat-7.0.61.tar.gz'
#   - download_path - optional - the absolute path under the content will be downloaded
#                   - Default: '/opt/apache-tomcat-7.0.61.tar.gz'
#   - folder_name - the folder name to be created where tomcat installing archive will be downloaded
#                 - Default: apache-tomcat-7.0.61.tar.gz
#   - folder_path - optional - the absolute path under the <folder_name> will be created - Default: '/opt'
#   - source_path - absolute path of the file about to be copied
#
# Outputs:
#    - returnResult - STDOUT of the remote machine in case of success or the cause of the error in case of exception
#    - standard_out - STDOUT of the machine in case of successful request, null otherwise
#    - standard_err - STDERR of the machine in case of successful request, null otherwise
#    - exception - contains the stack trace in case of an exception
#    - command_return_code - The return code of the remote command corresponding to the SSH channel. The return code is
#                            only available for certain types of channels, and only after the channel was closed
#                            (more exactly, just before the channel is closed).
#	                         Examples: 0 for a successful command, -1 if the command was not yet terminated (or this
#                                      channel type has no command), 126 if the command cannot execute.
# Results:
#    - SUCCESS - SSH access was successful
#    - FAILURE - otherwise
####################################################
namespace: io.cloudslang.base.os.linux.samples

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  remote: io.cloudslang.base.remote_command_execution.remote_file_transfer
  folders: io.cloudslang.base.os.linux.folders
  groups: io.cloudslang.base.os.linux.groups
  users: io.cloudslang.base.os.linux.users
  strings: io.cloudslang.base.strings

flow:
  name: deploy_tomcat

  inputs:
    - host
    - root_password
    - user_password:
        default: ''
        required: false
    - download_url: 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.61/bin/apache-tomcat-7.0.61.tar.gz'
    - download_path:
        default: '/opt/apache-tomcat-7.0.61.tar.gz'
        required: false
    - folder_name: 'apache-tomcat-7.0.61.tar.gz'
    - folder_path:
        default: '/opt'
        required: false

  workflow:
    - verify_group_exist:
        do:
          groups.verify_group_exist:
            - host
            - root_password
            - group_name: 'tomcat'
        publish:
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - message
        navigate:
          SUCCESS: check_group_not_exist_result
          FAILURE: SSH_VERIFY_GROUP_EXIST_FAILURE

    - check_group_not_exist_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${message}
            - string_to_find: 'group does not exist'
        navigate:
          SUCCESS: add_group
          FAILURE: check_group_exist_result

    - check_group_exist_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${message}
            - string_to_find: 'group exist'
        navigate:
          SUCCESS: add_user
          FAILURE: CHECK_GROUP_FAILURE

    - add_group:
        do:
          groups.add_group:
            - host
            - root_password
            - group_name: 'tomcat'
        publish:
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          SUCCESS: add_user
          FAILURE: ADD_GROUP_FAILURE

    - add_user:
        do:
          users.add_user:
            - host
            - root_password
            - user_name: 'tomcat'
            - user_password
            - group_name: 'tomcat'
            - create_home: True
            - home_path: '/usr/share/tomcat'
        publish:
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          SUCCESS: prepare_for_download
          FAILURE: ADD_USER_FAILURE

    - prepare_for_download:
        do:
          folders.make_new_folder:
            - host
            - root_password
            - folder_name
            - folder_path
        publish:
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          SUCCESS: download_tomcat
          FAILURE: CREATE_DOWNLOADING_FOLDER_FAILURE

    - download_tomcat:
        do:
          folders.download_content:
            - host
            - root_password
            - download_url
            - download_path
        publish:
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          SUCCESS: untar_tomcat
          FAILURE: DOWNLOAD_TOMCAT_APPLICATION_FAILURE

    - untar_tomcat:
        do:
          ssh.ssh_flow:
            - host
            - command: >
               ${'cd ' + folder_path + '/' + folder_name + ' && tar xvf -C ' + folder_path + '/' + folder_name +
               ' --strip-components=1'}
            - username: 'root'
            - password: ${root_password}
        publish:
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - exception
        navigate:
          SUCCESS: create_symlink
          FAILURE: UNTAR_TOMCAT_APPLICATION_FAILURE

    - create_symlink:
        do:
          folders.create_folder_symlink:
            - host
            - root_password
            - source_folder: ${folder_path + '/' + folder_name}
            - linked_folder: '/usr/share/tomcat'
        publish:
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          SUCCESS: change_tomcat_folder_ownership
          FAILURE: CREATE_SYMLINK_FAILURE

    - change_tomcat_folder_ownership:
        do:
          folders.change_folder_ownership:
            - host
            - root_password
            - folder_path: '/usr/share/tomcat/'
            - user_name: 'tomcat'
            - group_name: 'tomcat'
            - recursively: True
        publish:
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          SUCCESS: create_init_tomcat_folder
          FAILURE: CHANGE_TOMCAT_FOLDER_OWNERSHIP_FAILURE

    - create_init_tomcat_folder:
        do:
          folders.make_new_folder:
            - host
            - root_password
            - folder_name: 'tomcat'
            - folder_path: '/etc/init.d'
        publish:
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          SUCCESS: upload_server_config_file
          FAILURE: CREATE_INITIALIZATION_FOLDER_FAILURE

    - upload_server_config_file:
        do:
          remote.remote_secure_copy:
            - sourcePath: ${source_path}
            - destinationHost: ${host}
            - destinationPath: '/etc/init.d/tomcat'
            - destinationUsername: 'root'
            - destinationPassword: ${root_password}
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          SUCCESS: change_tomcat_initialization_folder_permissions
          FAILURE: UPLOAD_SERVER_CONFIG_FILE_FAILURE

    - change_tomcat_initialization_folder_permissions:
        do:
          folders.change_permissions:
            - host
            - root_password
            - folder_path: '/etc/init.d/tomcat'
            - permissions_code: '755'
            - recursively: True
        publish:
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          SUCCESS: upload_server_config_file
          FAILURE: CHANGE_PERMISSIONS_FAILURE

    - upload_server_config_file:
        do:
          remote.remote_secure_copy:
            - sourcePath: ${source_path}
            - destinationHost: ${host}
            - destinationPath: '/usr/share/tomcat/conf'
            - destinationUsername: 'tomcat'
            - destinationPassword: ${user_password}
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          SUCCESS: upload_users_config_file
          FAILURE: UPLOAD_SERVER_CONFIG_FILE_FAILURE

    - upload_users_config_file:
        do:
          remote.remote_secure_copy:
            - sourcePath: ${source_path}
            - destinationHost: ${host}
            - destinationPath: '/usr/share/tomcat/conf'
            - destinationUsername: 'tomcat'
            - destinationPassword: ${user_password}
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          SUCCESS: SUCCESS
          FAILURE: UPLOAD_USERS_CONFIG_FILE_FAILURE

  outputs:
    - standard_err
    - standard_out
    - return_code
    - command_return_code

  results:
    - SUCCESS
    - SSH_VERIFY_GROUP_EXIST_FAILURE
    - CHECK_GROUP_FAILURE
    - ADD_GROUP_FAILURE
    - ADD_USER_FAILURE
    - CREATE_DOWNLOADING_FOLDER_FAILURE
    - DOWNLOAD_TOMCAT_APPLICATION_FAILURE
    - UNTAR_TOMCAT_APPLICATION_FAILURE
    - CREATE_SYMLINK_FAILURE
    - CHANGE_TOMCAT_FOLDER_OWNERSHIP_FAILURE
    - CREATE_INITIALIZATION_FOLDER_FAILURE
    - CHANGE_PERMISSIONS_FAILURE
    - UPLOAD_SERVER_CONFIG_FILE_FAILURE
    - UPLOAD_USERS_CONFIG_FILE_FAILURE
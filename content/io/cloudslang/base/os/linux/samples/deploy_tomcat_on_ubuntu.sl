# (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs several linux commands in order to deploy Tomcat application on machines that are running Ubuntu based linux
#! @prerequisites: Java package
#! @input host: hostname or IP address
#! @input root_password: the root password
#! @input user_password: optional - the Tomcat user password - Default: ''
#! @input java_version: the java version that will be installed - Example: openjdk-7-jdk
#! @input download_url: the URL address where the content to be downloaded is
#! @input download_path: optional - the absolute path under the content will be downloaded - Default: '/opt/apache-tomcat'
#! @input folder_name: the folder name to be created where tomcat installing archive will be downloaded - Default: 'apache-tomcat'
#! @input folder_path: optional - the absolute path under the <folder_name> will be created - Default: '/opt'
#! @input file_name: the name of the Tomcat archive file - Example: 'apache-tomcat-7.0.61.tar.gz'
#! @input source_path: absolute path of the file to be copied - Example: 'C:\temp\tomcat'
#! @input permissions_code: the number that represents octal code of the folder permissions granted - Example: '755'
#! @input recursively: if True then the permissions will be granted for entire content of the targeted folder, if False
#!                     the permissions will granted only to the folder itself - Default: True
#! @input script_file_name: the name of the script file
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: 0 for a successful command, -1 if the command was not yet terminated (or this
#!                              channel type has no command), 126 if the command cannot execute.
#! @result SUCCESS: SSH access was successful
#! @result FAILURE: otherwise
#!!#
####################################################
namespace: io.cloudslang.base.os.linux.samples

imports:
  ssh: io.cloudslang.base.ssh
  remote: io.cloudslang.base.remote_file_transfer
  folders: io.cloudslang.base.os.linux.folders
  groups: io.cloudslang.base.os.linux.groups
  users: io.cloudslang.base.os.linux.users
  samples: io.cloudslang.base.os.linux.samples
  strings: io.cloudslang.base.strings

flow:
  name: deploy_tomcat_on_ubuntu

  inputs:
    - host
    - root_password:
        sensitive: true
    - user_password:
        default: ''
        required: false
        sensitive: true
    - java_version
    - download_url
    - download_path:
        default: '/opt/apache-tomcat'
        required: false
    - folder_name: 'apache-tomcat'
    - folder_path:
        default: '/opt'
        required: false
    - file_name
    - source_path
    - permissions_code: '755'
    - recursively: True
    - script_file_name


  workflow:
    - install_java:
        do:
          samples.install_java_on_ubuntu:
            - host
            - root_password
            - java_version
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - exception
        navigate:
          - SUCCESS: verify_group_exist
          - FAILURE: INSTALL_JAVA_FAILURE

    - verify_group_exist:
        do:
          groups.verify_group_exist:
            - host
            - root_password
            - group_name: 'tomcat'
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - message
        navigate:
          - SUCCESS: check_group_not_exist_result
          - FAILURE: SSH_VERIFY_GROUP_EXIST_FAILURE

    - check_group_not_exist_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${message}
            - string_to_find: 'group does not exist'
        navigate:
          - SUCCESS: add_group
          - FAILURE: check_group_exist_result

    - check_group_exist_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${message}
            - string_to_find: 'group exist'
        navigate:
          - SUCCESS: add_user
          - FAILURE: CHECK_GROUP_FAILURE

    - add_group:
        do:
          groups.add_ubuntu_group:
            - host
            - root_password
            - group_name: 'tomcat'
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: add_user
          - FAILURE: ADD_GROUP_FAILURE

    - add_user:
        do:
          users.add_ubuntu_user:
            - host
            - root_password
            - user_name: 'tomcat'
            - user_password
            - group_name: 'tomcat'
            - create_home: True
            - home_path: '/usr/share/tomcat'
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: prepare_for_download
          - FAILURE: ADD_USER_FAILURE

    - prepare_for_download:
        do:
          folders.make_new_folder:
            - host
            - root_password
            - folder_name
            - folder_path
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: download_tomcat
          - FAILURE: CREATE_DOWNLOADING_FOLDER_FAILURE

    - download_tomcat:
        do:
          folders.download_content:
            - host
            - root_password
            - download_url
            - download_path
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: untar_tomcat
          - FAILURE: DOWNLOAD_TOMCAT_APPLICATION_FAILURE

    - untar_tomcat:
        do:
          ssh.ssh_flow:
            - host
            - command: >
               ${'cd ' + folder_path + '/' + folder_name + ' && tar pxvf ' + file_name + ' --strip-components=1'}
            - username: 'root'
            - password: ${root_password}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - exception
        navigate:
          - SUCCESS: create_symlink
          - FAILURE: UNTAR_TOMCAT_APPLICATION_FAILURE

    - create_symlink:
        do:
          folders.create_symlink:
            - host
            - root_password
            - source_folder: ${folder_path + '/' + folder_name}
            - linked_folder: '/usr/share/tomcat'
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: install_tomcat
          - FAILURE: CREATE_SYMLINK_FAILURE

    - install_tomcat:
        do:
          ssh.ssh_flow:
            - host
            - command: ${'cd /usr/share/tomcat/' + folder_name + '/bin' + ' && ./startup.sh'}
            - username: 'root'
            - password: ${root_password}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - exception
        navigate:
          - SUCCESS: change_tomcat_folder_ownership
          - FAILURE: INSTALL_TOMCAT_APPLICATION_FAILURE

    - change_tomcat_folder_ownership:
        do:
          folders.change_ownership:
            - host
            - root_password
            - folder_path: '/usr/share/tomcat/'
            - user_name: 'tomcat'
            - group_name: 'tomcat'
            - recursively
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: change_download_tomcat_folder_ownership
          - FAILURE: CHANGE_TOMCAT_FOLDER_OWNERSHIP_FAILURE

    - change_download_tomcat_folder_ownership:
        do:
          folders.change_ownership:
            - host
            - root_password
            - folder_path: ${download_path}
            - user_name: 'tomcat'
            - group_name: 'tomcat'
            - recursively
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: create_init_tomcat_folder
          - FAILURE: CHANGE_DOWNLOAD_TOMCAT_FOLDER_OWNERSHIP_FAILURE

    - create_init_tomcat_folder:
        do:
          folders.make_new_folder:
            - host
            - root_password
            - folder_name: 'tomcat'
            - folder_path: '/etc/init.d'
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: upload_init_config_file
          - FAILURE: CREATE_INITIALIZATION_FOLDER_FAILURE

    - upload_init_config_file:
        do:
          remote.remote_secure_copy:
            - source_path
            - destination_host: ${host}
            - destination_path: '/etc/init.d/tomcat'
            - destination_username: 'root'
            - destination_password: ${root_password}
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: change_tomcat_initialization_folder_permissions
          - FAILURE: UPLOAD_INIT_CONFIG_FILE_FAILURE

    - change_tomcat_initialization_folder_permissions:
        do:
          folders.change_permissions:
            - host
            - root_password
            - folder_path: '/etc/init.d/tomcat'
            - permissions_code
            - recursively
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: start_tomcat
          - FAILURE: CHANGE_PERMISSIONS_FAILURE

    - start_tomcat:
        do:
          ssh.ssh_flow:
            - host
            - command: >
                ${'cd /etc/init.d/tomcat && ./' + script_file_name + ' start'}
            - username: 'root'
            - password: ${root_password}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: START_TOMCAT_APPLICATION_FAILURE

  outputs:
    - return_result
    - standard_err
    - standard_out
    - return_code
    - command_return_code

  results:
    - SUCCESS
    - INSTALL_JAVA_FAILURE
    - SSH_VERIFY_GROUP_EXIST_FAILURE
    - CHECK_GROUP_FAILURE
    - ADD_GROUP_FAILURE
    - ADD_USER_FAILURE
    - CREATE_DOWNLOADING_FOLDER_FAILURE
    - DOWNLOAD_TOMCAT_APPLICATION_FAILURE
    - UNTAR_TOMCAT_APPLICATION_FAILURE
    - CREATE_SYMLINK_FAILURE
    - INSTALL_TOMCAT_APPLICATION_FAILURE
    - CHANGE_TOMCAT_FOLDER_OWNERSHIP_FAILURE
    - CHANGE_DOWNLOAD_TOMCAT_FOLDER_OWNERSHIP_FAILURE
    - CREATE_INITIALIZATION_FOLDER_FAILURE
    - UPLOAD_INIT_CONFIG_FILE_FAILURE
    - CHANGE_PERMISSIONS_FAILURE
    - START_TOMCAT_APPLICATION_FAILURE

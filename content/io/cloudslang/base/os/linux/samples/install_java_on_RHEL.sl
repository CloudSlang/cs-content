# (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!! 
#! @description: This flow performs several linux commands in order to install java on machines running Ubuntu RHEL (tested on RHEL6.x)
#!
#! @input host: hostname or IP address
#! @input root_password: the root password
#! @input java_version: the java version that will be installed
#! @input set_default: optional - choose whether to set the java version that will be installed as default or keep the current version
#!                     Valid: True, False
#!                     Default: True
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: the return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!	                            Examples: 0 for a successful command, -1 if the command was not yet terminated (or this
#!                              channel type has no command), 126 if the command cannot execute.
#! @output default_java: what java version running on the machine
#! @result SUCCESS: SSH access was successful
#! @result FAILURE:otherwise
#!!#
####################################################
namespace: io.cloudslang.base.os.linux.samples

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings
flow:
  name: install_java_on_RHEL

  inputs:
    - host
    - root_password
    - java_version
    - set_default:
        default: 'true'
        required: false

  workflow:
    - install_java:
        do:
          ssh.ssh_flow:
            - host
            - username: 'root'
            - password: ${root_password}
            - command: ${'yum install -y ' + java_version}
        publish:
          - default_java: 'currently installed java version will be used'
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - exception
        navigate:
          SUCCESS: is_default
          FAILURE: FAILED_JAVA_INSTALLATION

    - is_default:
        do:
          strings.string_equals:
            - first_string: ${set_default}
            - second_string: 'true'
        navigate:
          SUCCESS: strip_java_input
          FAILURE: KEEP_DEFAULT_JAVA


    - strip_java_input:
        do:
          strings.regex_replace:
            - regex: 'java-'
            - text: ${java_version}
            - replacement: ""
        publish:
          - version: ${result_text}
        navigate:
          SUCCESS: run_alternatives_java

    - run_alternatives_java:
        do:
          ssh.ssh_flow:
            - username: 'root'
            - host: ${host}
            - password: ${root_password}
            - command: ${'echo $(alternatives --config java <<< d 2> /dev/null| grep ' + version + ' | tail -1 | head -c4 ) | egrep -o ''[0-9]'' | alternatives --config java'}
        publish:
          - default_java: ${self['java_version'] + ' will be set as default'}



  outputs:
      - return_result
      - standard_err
      - standard_out
      - return_code
      - command_return_code
      - exception
      - default_java
  results:
      - SUCCESS
      - KEEP_DEFAULT_JAVA
      - FAILURE
      - FAILED_JAVA_INSTALLATION

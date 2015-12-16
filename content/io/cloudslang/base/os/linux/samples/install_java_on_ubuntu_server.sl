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
#   - java_version - the java version that will be installed
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

flow:
  name: install_java_on_ubuntu_server

  inputs:
    - host
    - root_password
    - java_version: 'openjdk-7-jdk'

  workflow:
    - install_java:
        do:
          ssh.ssh_flow:
            - host
            - username: 'root'
            - password: ${root_password}
            - command: ${'apt-get install -y ' + java_version}
        publish:
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - exception

  outputs:
      - standard_err
      - standard_out
      - return_code
      - command_return_code
      - exception
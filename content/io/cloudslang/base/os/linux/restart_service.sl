# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow restart remote linux service thrue ssh
#
#   Inputs:
#       - service_name - linux service name to be restarted
#       - host - hostname or IP address
#       - port - port number for running the command
#       - command - command to execute
#       - pty - whether to use pty; valid values: true, false; Default: false
#       - username - username to connect as
#       - password - password of user
#       - arguments - arguments to pass to the command
#       - privateKeyFile - the absolute path to the private key file
#       - timeout - time in milliseconds to wait for the command to complete; Default: 90000 ms
#       - characterSet - character encoding used for input stream encoding from the target machine; valid values: SJIS, EUC-JP, UTF-8; Default: UTF-8;
#       - closeSession - if false the ssh session will be cached for future calls of this operation during the life of the flow
#                     if true the ssh session used by this operation will be closed; Valid values: true, false; Default: true
#
# For correct work of email part - system_property (mail.yaml) file should be filled and called as '--spf' input
#
# Results:
#  SUCCESS: service on linux host will be restarted
#  FAILURE: service cannot be restarted due to an error
# 
####################################################
namespace: io.cloudslang.base.os.linux

imports:
  ssh_command: io.cloudslang.base.remote_command_execution.ssh
  print: io.cloudslang.base.print

flow:
  name: restart_service

  inputs:
    - service_name
    - host
    - port:
        required: false
    - pty:
        default: "'false'"
    - username
    - password
    - arguments:
          required: false
    - privateKeyFile:
          required: false
    - timeout:
          default: "'90000'"
    - characterSet:
         default: "'UTF-8'"
    - closeSession:
          default: "'true'"


  workflow:
    - service_restart:
        do:
          ssh_command.ssh_command:
            - host
            - command: >
                "service " + service_name + " restart"
            - username
            - password
        publish: 
          - returnResult: returnResult
          - STDOUT: STDOUT
          - STDERR: STDERR
          - exception: FAILURE
      navigate:
          SUCCESS: print_success
          FAILURE: print_failure

    - print_success:
        do:
          print.print_text:
            - text: >
                "Result: " + str(STDOUT)

    - print_failure:
        do:
          print.print_text:
            - text: >
                "Result: " + str(STDERR)

    - print_result:
        do:
          print.print_text:
            - text: >
                str(returnResult)
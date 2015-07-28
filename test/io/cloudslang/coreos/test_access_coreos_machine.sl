#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Wrapper flow - logic steps:
# - retrieves the ip addresses of the machines in the cluster
# - cleanup on the machines (so they will not contain any images)
# - prepares a used and an unused Docker image
# - runs the flow
# - verifies only one image remained in the cluster
# - delete the used image
####################################################

namespace: io.cloudslang.coreos

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  print: io.cloudslang.base.print

flow:
  name: test_access_coreos_machine
  inputs:
    - coreos_host
    - coreos_username
    - coreos_password:
        required: false
    - private_key_file:
        required: false
    - percentage:
        required: false
    - timeout:
        required: false
    - unused_image_name:
        default: "'tomcat:7'"
    - used_image_name:
        default: "'busybox'"
    - number_of_images_in_cluster:
        default: 0
        overridable: false

  workflow:
    - test_ssh_access:
        do:
          ssh.ssh_flow:
            - host: coreos_host
            - command: "'fleetctl list-machines'"
            - username: coreos_username
            - privateKeyFile:
                default: private_key_file
                required: false
        publish:
            - returnResult

    - print_result:
        do:
          print.print_text:
            - text: >
                'ssh result -> ' + returnResult

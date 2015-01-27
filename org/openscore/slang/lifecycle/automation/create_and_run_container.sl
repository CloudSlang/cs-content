#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   This operation creates and runs a Docker container
##################################################################################################################################################

namespace: org.openscore.slang.lifecycle.automation

operations:
  - create_and_run_container:
        inputs:
            - docker_hub_user
            - image_name
            - version
            - host
            - port:
                default: "'22'"
            - username
            - password
            - privateKeyFile:
                default: "''"
            - arguments:
                default: "''"
                override: true
            - command:
                default: >
                    'docker run -p 8888:8080 -t -i ' + docker_hub_user + '/' + image_name + ':' + version
                override: true
            - characterSet:
                default: "'UTF-8'"
            - pty:
                default: "'false'"
            - timeout:
                default: "'90000'"
            - closeSession:
                default: "'false'"
        action:
          java_action:
              className: org.openscore.content.ssh.actions.SSHShellCommandAction
              methodName: runSshShellCommand
        results:
          - SUCCESS: returnCode == '0' and (not 'Error' in STDERR)
          - FAILURE

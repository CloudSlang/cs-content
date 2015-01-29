#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   This operation creates an image from a Dockerfile.
#
#   Inputs:
#       - docker_user - Docker username for creating images; it should be the same as the Docker Hub username
#       - image_name - name of the Docker image that is created
#       - version - version(tag) of the Docker image that is created
#       - path_dockerfile - path to folder that contains the Dockerfile the image is built from
#       - host - Docker machine host
#       - port - Docker machine port
#       - username - Docker machine username
#       - password - Docker machine password
#
#   Results:
#       - SUCCESS - the action returnCode is 0 (executed without exceptions) and the STDERR of the machine contains no errors
#       - FAILURE
##################################################################################################################################################

namespace: org.openscore.slang.lifecycle.automation

operations:
  - create_image:
        inputs:
            - docker_user
            - image_name
            - version
            - path_dockerfile
            - host
            - port:
                default: "'22'"
            - username
            - password
            - privateKeyFile:
                default: "''"
                override: true
            - arguments:
                default: "''"
                override: true
            - command:
                default: >
                    'docker build -t="' + docker_user + '/' + image_name + ':' + version + '" ' + path_dockerfile
                override: true
            - characterSet:
                default: "'UTF-8'"
                override: true
            - pty:
                default: "'false'"
                override: true
            - timeout:
                default: "'90000'"
                override: true
            - closeSession:
                default: "'false'"
                override: true
        action:
          java_action:
              className: org.openscore.content.ssh.actions.SSHShellCommandAction
              methodName: runSshShellCommand
        results:
          - SUCCESS: returnCode == '0' and (not 'Error' in STDERR)
          - FAILURE

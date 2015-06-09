#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Builds a Docker image based on a Dockerfile.
#
# Inputs:
#   - docker_user - optional - Docker username of the created image from a construct like 'docker_user/image_name:tag' - Default: no username
#   - image_name - name of the created image from a construct like 'docker_user/image_name:tag'
#   - tag - optional - tag of the created image from a construct like 'docker_user/image_name:tag' - Default: latest
#   - workdir - optional - path to the directory that contains the Dockerfile
#   - host - Docker machine host
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - privateKeyFile - optional - path to the private key file
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false - Default: false
#   - timeout - time in milliseconds to wait for command to complete - Default: 3000000 ms (50 min)
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false - Default: false
# Outputs:
#   - image_ID - ID of the created Docker image
# Results:
#   - SUCCESS - Docker image successfully built
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.docker.images

operation:
  name: build_image
  inputs:
    - docker_user:
        default: "''"
    - image_name
    - tag:
        default: "'latest'"
    - workdir:
        default: "'.'"
    - host
    - port:
        default: "'22'"
    - username
    - password:
        required: false
    - privateKeyFile:
        required: false
    - characterSet:
        default: "'UTF-8'"
    - pty:
        default: "'false'"
    - timeout:
        default: "'3000000'"
    - closeSession:
        default: "'false'"
    - docker_user_command:
        default: >
            '' if docker_user == '' else docker_user + "/"
        overridable: false
    - command:
        default: >
            'docker build -t="' + docker_user_command + image_name + ':' + tag + '" ' + workdir
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - image_ID: >
        STDOUT.split('Successfully built ')[1].replace('\n', '')
        if returnCode == '0' and ('Successfully built' in STDOUT)
        else ''
  results:
    - SUCCESS: >
        returnCode == '0' and ('Successfully built' in STDOUT)
    - FAILURE

#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will return a list populated with all Docker dangling images.
#
#   Inputs:
#       - host - Docker machine host
#       - port - optional - SSH port - Default: 22
#       - username - Docker machine username
#       - password - Docker machine password
#       - pty - whether to use pty; valid values: true, false; Default: false
#       - arguments - arguments to pass to the command; Default: none
#       - privateKeyFile - the absolute path to the private key file; Default: none
#       - timeout - time in milliseconds to wait for the command to complete; Default: 30000000 ms
#       - characterSet - character encoding used for input stream encoding from the target machine; valid values: SJIS, EUC-JP, UTF-8; Default: UTF-8;
#       - closeSession - if false the ssh session will be cached for future calls of this operation during the life of the flow
#                        if true the ssh session used by this operation will be closed; Valid values: true, false; Default: false
#   Outputs:
#       - dangling_image_list - list containing IDs of Docker dangling images
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################

namespace: org.openscore.slang.docker.images

operation:
  name: get_dangling_images
  inputs:
    - host
    - port: "'22'"
    - username
    - password
    - privateKeyFile: "''"
    - command: >
        "docker images -f \"dangling=true\" -q"
    - arguments: "''"
    - characterSet : "'UTF-8'"
    - pty: "'false'"
    - timeout: "'30000000'"
    - closeSession: "'false'"
  action:
    java_action:
      className: org.openscore.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - dangling_image_list: returnResult
  results:
    - SUCCESS: returnCode == '0' and (not 'Error' in STDERR)
    - FAILURE
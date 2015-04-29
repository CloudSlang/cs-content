#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#####################################################
# Retrieves the ID list of machines deployed in a CoreOS cluster.
#
# Inputs:
#   - host - CoreOS machine host - can be any machine from the cluster
#   - port - optional - SSH port - Default: 22
#   - username - CoreOS machine username
#   - password - CoreOS machine password; can be empty since with CoreOS machines private key file authentication is used
#   - privateKeyFile - optional - path to the private key file - Default: none
#   - arguments - optional - arguments to pass to the command - Default: none
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#   - pty - optional - whether to use pty - Valid: true, false - Default: false
#   - timeout - optional - time in milliseconds to wait for command to complete - Default: 90000
#   - closeSession - optional - if false SSH session will be cached for future calls of this operation during the life of the flow, if true SSH session used by this operation will be closed - Valid values: true, false - Default: false
# Outputs:
#   - machines_id_list  - space delimited list of IDs of machines deployed in the CoreOS cluster
# Results:
#   - SUCCESS - action was executed successfully and no error message is found in the STDERR
#   - FAILURE - otherwise
#####################################################

namespace: io.cloudslang.coreos

operation:
  name: list_machines_id
  inputs:
    - host
    - port:
        default: "'22'"
    - username
    - password
    - privateKeyFile:
        default: "''"
    - arguments:
        default: "''"
    - command:
        default: >
          "fleetctl list-machines | awk '{print $1}'"
        overridable: false
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
      className: io.cloudslang.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - machines_id_list: >
        returnResult.replace("\n"," ").replace("MACHINE ","",1).replace("...", "")[:-1]
        if (returnCode == '0' and (not 'ERROR' in STDERR)) else ''
  results:
    - SUCCESS: returnCode == '0' and (not 'ERROR' in STDERR)
    - FAILURE

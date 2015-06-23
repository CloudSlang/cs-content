#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#####################################################
# Retrieves the public IP address of a machine (based on its ID) deployed in a CoreOS cluster.
#
# Inputs:
#   - machine_id - ID of the machine
#   - host - CoreOS machine host; can be any machine from the cluster
#   - port - optional - SSH port - Default: 22
#   - username - CoreOS machine username
#   - password - CoreOS machine password; can be empty since CoreOS machines use private key file authentication
#   - privateKeyFile - optional - path to the private key file - Default: none
#   - arguments - optional - arguments to pass to the command - Default: none
#   - pty - whether to use PTY - Valid: true, false - Default: false
#   - timeout - time in milliseconds to wait for the command to complete - Default: 90000
#   - closeSession - if false SSH session will be cached for future calls of this operation during life of the flow, if true SSH session used by this operation will be closed - Valid: true, false - Default: false
# Outputs:
#   - public_ip: public IP address of the machine based on its ID
# Results:
#   - SUCCESS - the action was executed successfully and no error message is found in the STDERR
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.coreos

operation:
  name: get_machine_public_ip
  inputs:
    - machine_id
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
          "fleetctl --strict-host-key-checking=false  ssh " + machine_id + " cat /etc/environment"
        overridable: false
    - characterSet:
        default: "'UTF-8'"
    - pty:
        default: "'false'"
    - timeout:
        default: "'90000'"
    - closeSession:
        default: "'false'"
    - agentForwarding:
        default: "'true'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - public_ip: >
        returnResult[returnResult.find('COREOS_PUBLIC_IPV4') + len('COREOS_PUBLIC_IPV4') + 1 : -1]
  results:
    - SUCCESS: (returnCode == '0') and (not 'ssh-agent' in STDERR) and (not 'ERROR' in STDERR)
    - FAILURE

#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
# Performs an VMware vSphere command in order to power on a specified powered off virtual machine
#
# Inputs:
#   - host - VMware host or IP - Example: 'vc6.subdomain.example.com'
#   - port - optional - the port to connect through - Examples: '443', '80' - Default: '443'
#   - protocol - optional - the connection protocol - Valid: 'http', 'https' - Default: 'https'
#   - username - optional - the VMware username use to connect
#   - password - the password associated with <username> input
#   - trust_everyone - optional - if 'True' will allow connections from any host, if 'False' the connection will be
#                                allowed only using a valid vCenter certificate - Default: True
#   - virtual_machine_name - the name of the virtual machine that will be powered on
# Outputs:
#   - return_result - contains the exception in case of failure, success message otherwise
#   - return_code - '0' if operation was successfully executed, '-1' otherwise
#   - error_message - error message if there was an error when executing, empty otherwise
# Results:
#   - SUCCESS: the specified virtual machine was successfully powered on
#   - FAILURE: an error occurred when trying to power on the specified virtual machine
########################################################################################################################

namespace: io.cloudslang.cloud_provider.vmware.virtual_machines

operation:
  name: power_on_virtual_machine
  inputs:
    - host
    - port:
        default: '443'
        required: false
    - protocol:
        default: 'https'
        required: false
    - username:
        required: false
    - password
    - trust_everyone:
        default: 'true'
        required: false
    - trustEveryone:
        default: ${get("trust_everyone", "true")}
        overridable: false
    - virtual_machine_name
    - virtualMachineName: ${virtual_machine_name}

  action:
    java_action:
      className: io.cloudslang.content.vmware.actions.vm.PowerOnVM
      methodName: powerOnVM

  outputs:
    - return_result: ${'' if 'returnResult' not in locals() else returnResult}
    - error_message: ${(exception if 'exception' in locals() or returnResult if returnCode != '0') else ''}
    - return_code: ${returnCode}

  results:
    - SUCCESS : ${returnCode == '0'}
    - FAILURE
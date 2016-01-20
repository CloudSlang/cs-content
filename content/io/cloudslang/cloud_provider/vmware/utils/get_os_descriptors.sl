#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
# Performs an VMware vSphere command in order to list all supported guest OSes on a host system
#
# Inputs:
#   - host - VMware host or IP - Example: 'vc6.subdomain.example.com'
#   - port - optional - the port to connect through - Examples: '443', '80' - Default: '443'
#   - protocol - optional - the connection protocol - Valid: 'http', 'https' - Default: 'https'
#   - username - the VMware username use to connect
#   - password - the password associated with <username> input
#   - trust_everyone - optional - if 'True' will allow connections from any host, if 'False' the connection will be
#                               allowed only using a valid vCenter certificate - Default: True
#   - data_center_name - the data center name where the host system is - Example: 'DataCenter2'
#   - hostname - the name of the target host to be queried to retrieve the supported guest OSes
#              - Example: 'host123.subdomain.example.com'
#   - delimiter - the delimiter that will be used in response list - Default: ','
#
# Outputs:
#   - return_result - contains the exception in case of failure, success message otherwise
#   - return_code - '0' if operation was successfully executed, '-1' otherwise
#   - error_message - error message if there was an error when executing, empty otherwise
# Results:
#   - SUCCESS: the list with all supported guest OSes was successfully retrieved
#   - FAILURE: an error occurred when trying to retrieve a list with all supported guest OSes
########################################################################################################################

namespace: io.cloudslang.cloud_provider.vmware.utils

operation:
  name: get_os_descriptors
  inputs:
    - host
    - port:
        default: '443'
        required: false
    - protocol:
        default: 'https'
        required: false
    - username
    - password
    - trust_everyone:
        default: 'true'
        required: false
    - trustEveryone:
        default: ${get("trust_everyone", "true")}
        overridable: false
    - data_center_name
    - dataCenterName: ${data_center_name}
    - hostname
    - delimiter:
        default: ','
        required: false

  action:
    java_action:
      className: io.cloudslang.content.vmware.actions.vm.conf.GetOSDescriptors
      methodName: getOsDescriptors

  outputs:
    - return_result: ${'' if 'returnResult' not in locals() else returnResult}
    - error_message: >
        ${exception if 'exception' in locals() else returnResult if returnCode != '0' else ''}
    - return_code: ${returnCode}

  results:
    - SUCCESS : ${returnCode == '0'}
    - FAILURE
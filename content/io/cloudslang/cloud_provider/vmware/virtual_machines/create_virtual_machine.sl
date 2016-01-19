#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
# Performs an VMware vSphere command in order to create a new virtual machine
#
# Inputs:
#   - host - VMware host or IP - Example: 'vc6.subdomain.example.com'
#   - port - optional - the port to connect through - Examples: '443', '80' - Default: '443'
#   - protocol - optional - the connection protocol - Valid: 'http', 'https' - Default: 'https'
#   - username - optional - the VMware username use to connect
#   - password - the password associated with <username> input
#   - trust_everyone - optional - if 'True' will allow connections from any host, if 'False' the connection will be
#                                allowed only using a valid vCenter certificate - Default: True
#   - data_center_name - the virtual machine's data center name - Example: 'DataCenter2'
#   - hostname - optional - the name of the host where the new created virtual machine will reside
#                         - Example: 'host123.subdomain.example.com' - Default: ''
#   - virtual_machine_name - the name of the virtual machine that will be created
#   - description - optional - the description of the virtual machine that will be created
#   - data_store - the datastore where the disk of the new created virtual machine will reside - Example: 'datastore2-vc6-1'
#   - num_cpus - optional - the number that indicates how many processors will have the virtual machine that will be created
#                        - Default: '1'
#   - vmDiskSize - optional - the disk capacity amount (in Mb) attached to the virtual machine that will be created
#                           - Default: '1024'
#   - vmMemorySize - optional - the memory amount (in Mb) attached to the virtual machine that will be created
#                             - Default: '1024'
#   - guest_os_id - the operating system associated with the new created virtual machine. The value for this input can
#                   be obtained by running utils/get_os_descriptors operation - Examples: 'winXPProGuest', 'win95Guest',
#                   'centosGuest', 'fedoraGuest', 'freebsd64Guest'
#
# Outputs:
#   - return_result - contains the exception in case of failure, success message otherwise
#   - return_code - '0' if operation was successfully executed, '-1' otherwise
#   - error_message - error message if there was an error when executing, empty otherwise
# Results:
#   - SUCCESS: the virtual machine was successfully created
#   - FAILURE: an error occurred when trying to create a new virtual machine
########################################################################################################################

namespace: io.cloudslang.cloud_provider.vmware.virtual_machines

operation:
  name: create_virtual_machine
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
    - data_center_name
    - dataCenterName: ${data_center_name}
    - hostname:
        default: ''
        required: false
    - virtual_machine_name
    - virtualMachineName: ${virtual_machine_name}
    - description:
        default: ''
        required: false
    - data_store
    - dataStore: ${data_store}
    - num_cpus:
        default: '1'
        required: false
    - numCPUs:
        default: ${get("num_cpus", "1")}
        overridable: false
    - vm_disk_size:
        default: '1024'
        required: false
    - vmDiskSize:
        default: ${get("vm_disk_size", "1024")}
        overridable: false
    - vm_memory_size:
        default: '1024'
        required: false
    - vmMemorySize:
        default: ${get("vm_memory_size", "1024")}
        overridable: false
    - guest_os_id
    - guestOsId: ${guest_os_id}

  action:
    java_action:
      className: io.cloudslang.content.vmware.actions.vm.CreateVM
      methodName: createVM

  outputs:
    - return_result: ${'' if 'returnResult' not in locals() else returnResult}
    - error_message: >
        ${exception if 'exception' in locals() else returnResult if returnCode != '0' else ''}
    - return_code: ${returnCode}

  results:
    - SUCCESS : ${returnCode == '0'}
    - FAILURE
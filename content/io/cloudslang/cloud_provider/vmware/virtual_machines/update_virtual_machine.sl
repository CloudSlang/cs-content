#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
# Performs an VMware vSphere command in order to update a specified virtual machine
#
# Prerequisites: vim25.jar
#   How to obtain vim25.jar:
#     1. Go to https://my.vmware.com/web/vmware and register;
#     2. Go to https://my.vmware.com/group/vmware/get-download?downloadGroup=MNGMTSDK600 and download the VMware-vSphere-SDK-6.0.0-2561048.zip;
#     3. Locate the vim25.jar into ../VMware-vSphere-SDK-6.0.0-2561048/SDK/vsphere-ws/java/JAXWS/lib;
#     4. Add the vim25.jar into the ClodSlang CLI folder under /cslang/lib
#
# Inputs:
#   - host - VMware host or IP - Example: 'vc6.subdomain.example.com'
#   - port - optional - the port to connect through - Examples: '443', '80' - Default: '443'
#   - protocol - optional - the connection protocol - Valid: 'http', 'https' - Default: 'https'
#   - username - the VMware username use to connect
#   - password - the password associated with <username> input
#   - trust_everyone - optional - if 'True' will allow connections from any host, if 'False' the connection will be
#                                 allowed only using a valid vCenter certificate - Default: True
#                                 Check the: https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_java_development.4.3.html
#                                 to see how to import a certificate into Java Keystore and
#                                 https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_sg_server_certificate_Appendix.6.4.html
#                                 to see how to obtain a valid vCenter certificate
#   - virtual_machine_name - the name of the virtual machine that will be updated
#   - operation - the possible operations that can be applied to update a specified attached device ("update" operation
#                 is only possible for cpu and memory, "add", "remove" are not allowed for cpu and memory devices)
#                 Valid values: "add", "remove", "update"
#   - device - the device on which the update operation will be applied - Valid values: "cpu", "memory", "disk", "cd",
#              "nic"
#   - update_value - optional - the value applied on the specified device during the virtual machine update
#                             - Valid values: "high", "low", "normal", numeric value, label of device when removing
#                               This input will be considered only when "update" operation is provided - Default: ''
#   - vm_disk_size - optional - the disk capacity amount (in Mb) attached to the virtual machine that will be created.
#                             This input will be considered only when "add" operation and "disk" device are provided
#                             - Default: '1024'
#   - vm_disk_mode - optional - the property that specifies how the disk will be attached to the virtual machine
#                           - Valid values: "persistent", "independent_persistent", "independent_nonpersistent"
#                             This input will be considered only when "add" operation and "disk" device are provided
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
  name: update_virtual_machine
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
    - virtual_machine_name
    - virtualMachineName: ${virtual_machine_name}
    - operation
    - device
    - update_value:
        default: ''
        required: false
    - updateValue:
        default: ${update_value}
        overridable: false
    - vm_disk_size:
        default: ''
        required: false
    - vmDiskSize:
        default: ${vm_disk_size}
        overridable: false
    - vm_disk_mode:
        default: ''
        required: false
    - vmDiskMode:
        default: ${vm_disk_mode}
        overridable: false

  action:
    java_action:
      className: io.cloudslang.content.vmware.actions.vm.UpdateVM
      methodName: updateVM

  outputs:
    - return_result: ${'' if 'returnResult' not in locals() else returnResult}
    - error_message: >
        ${exception if 'exception' in locals() else returnResult if returnCode != '0' else ''}
    - return_code: ${returnCode}

  results:
    - SUCCESS : ${returnCode == '0'}
    - FAILURE
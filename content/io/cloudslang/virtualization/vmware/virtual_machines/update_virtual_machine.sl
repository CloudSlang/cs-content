#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs a VMware vSphere command to update a specified virtual machine.
#!
#! @prerequisites: vim25.jar
#!   How to obtain the vim25.jar:
#!     1. Go to https://my.vmware.com/web/vmware and register.
#!     2. Go to https://my.vmware.com/group/vmware/get-download?downloadGroup=MNGMTSDK600 and download the VMware-vSphere-SDK-6.0.0-2561048.zip.
#!     3. Locate the vim25.jar in ../VMware-vSphere-SDK-6.0.0-2561048/SDK/vsphere-ws/java/JAXWS/lib.
#!     4. Copy the vim25.jar into the ClodSlang CLI folder under /cslang/lib.
#!
#! Inputs:
#! @input host: VMware host or IP
#!              example: 'vc6.subdomain.example.com'
#! @input port: port to connect through
#!              optional
#!              examples: '443', '80'
#!              default: '443'
#! @input protocol: connection protocol
#!                  optional
#!                  valid: 'http', 'https'
#!                  default: 'https'
#! @input username: VMware username to connect with
#! @input password: password associated with <username> input
#! @input trust_everyone: if 'True', will allow connections from any host, if 'False', connection will be
#!                        allowed only using a valid vCenter certificate
#!                        optional
#!                        default: True
#!                        Check https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_java_development.4.3.html
#!                        to see how to import a certificate into Java Keystore and
#!                        https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_sg_server_certificate_Appendix.6.4.html
#!                        to see how to obtain a valid vCenter certificate.
#! @input virtual_machine_name: name of virtual machine that will be updated
#! @input operation: possible operations that can be applied to update a specified attached device ("update" operation
#!                   is only possible for cpu and memory, "add", "remove" are not allowed for cpu and memory devices)
#!                   valid: "add", "remove", "update"
#! @input device: device on which update operation will be applied
#!                valid: "cpu", "memory", "disk", "cd", "nic"
#! @input update_value: value applied on the specified device during the virtual machine update
#!                      optional
#!                      valid: "high", "low", "normal", numeric value, label of device when removing
#!                      default: ''
#!                      This input will be considered only when "update" operation is provided.
#! @input vm_disk_size: disk capacity (in Mb) attached to the virtual machine that will be created.
#!                             This input will be considered only when "add" operation and "disk" device are provided.
#!                             optional
#!                             default: '1024'
#! @input vm_disk_mode: property that specifies how the disk will be attached to the virtual machine
#!                      optional
#!                      valid: "persistent", "independent_persistent", "independent_nonpersistent"
#!                      This input will be considered only when "add" operation and "disk" device are provided.
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: virtual machine was successfully created
#! @result FAILURE: an error occurred when trying to create a new virtual machine
#!!#
########################################################################################################################

namespace: io.cloudslang.virtualization.vmware.virtual_machines

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
    - password:
        sensitive: true
    - trust_everyone:
        required: false
    - trustEveryone:
        default: ${get("trust_everyone", "true")}
        private: true
    - virtual_machine_name
    - virtualMachineName:
        default: ${get("virtual_machine_name", None)}
        private: true
        required: false
    - operation
    - device
    - update_value:
        required: false
    - updateValue:
        default: ${get("update_value", "")}
        private: true
        required: false
    - vm_disk_size:
        required: false
    - vmDiskSize:
        default: ${get("vm_disk_size", "1024")}
        private: true
    - vm_disk_mode:
        required: false
    - vmDiskMode:
        default: ${get("vm_disk_mode", "")}
        private: true
        required: false

  java_action:
    gav: 'io.cloudslang.content:score-vmware:0.0.4'
    class_name: io.cloudslang.content.vmware.actions.vm.UpdateVM
    method_name: updateVM

  outputs:
    - return_result: ${get("returnResult", "")}
    - error_message: ${get("exception", returnResult if returnCode != '0' else '')}
    - return_code: ${returnCode}

  results:
    - SUCCESS : ${returnCode == '0'}
    - FAILURE

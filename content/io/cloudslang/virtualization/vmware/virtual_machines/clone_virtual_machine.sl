#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs a VMware vSphere command in order to clone an existing virtual machine.
#!
#! @prerequisites: vim25.jar
#!   How to obtain the vim25.jar:
#!     1. Go to https://my.vmware.com/web/vmware and register.
#!     2. Go to https://my.vmware.com/group/vmware/get-download?downloadGroup=MNGMTSDK600 and download the VMware-vSphere-SDK-6.0.0-2561048.zip.
#!     3. Locate the vim25.jar in ../VMware-vSphere-SDK-6.0.0-2561048/SDK/vsphere-ws/java/JAXWS/lib.
#!     4. Copy the vim25.jar into the ClodSlang CLI folder under /cslang/lib.
#!
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
#! @input data_center_name: data center name where host system is
#!                          example: 'DataCenter2'
#! @input hostname: name of target host to be queried to retrieve supported guest OSes
#!                  example: 'host123.subdomain.example.com'
#! @input virtual_machine_name: name of virtual machine that will be cloned
#! @input clone_name: name that will be assigned to the cloned virtual machine
#! @input folder_name: name of the folder where the cloned virtual machine will reside. If not provided then the top parent
#!                     folder will be used
#!                     optional
#!                     default: ''
#! @input clone_host: the host for the cloned virtual machine. If not provided then the same host of the virtual machine
#!                    that will be cloned will be used
#!                    optional
#!                    default: ''
#!                    example: 'host123.subdomain.example.com'
#! @input clone_resource_pool: the resource pool for the cloned virtual machine. If not provided then the parent resource
#!                             pool will be used
#!                             optional
#!                             default: ''
#! @input clone_data_store: datastore where disk of newly cloned virtual machine will reside. If not provided then the
#!                          datastore of the cloned virtual machine will be used
#!                          optional
#!                          default: ''
#!                          example: 'datastore2-vc6-1'
#! @input thick_provision: whether the provisioning of the cloned virtual machine will be thick or not
#!                         optional
#!                         default: False
#! @input is_template: whether the cloned virtual machine will be a template or not
#!                     optional
#!                     default: False
#! @input num_cpus: number that indicates how many processors the newly cloned virtual machine will have
#!                  optional
#!                  default: '1'
#! @input cores_per_socket: number that indicates how many cores per socket the newly cloned virtual machine will have
#!                          optional
#!                          default: '1'
#! @input memory: amount of memory (in Mb) attached to cloned virtual machined
#!                optional
#!                default: '1024'
#! @input clone_description: description of virtual machine that will be cloned
#!                           optional
#!                           default: ''
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: virtual machine was successfully cloned
#! @result FAILURE: an error occurred when trying to clone an existing virtual machine
#!!#
########################################################################################################################

namespace: io.cloudslang.virtualization.vmware.virtual_machines

operation:
  name: clone_virtual_machine
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
    - data_center_name
    - dataCenterName:
        default: ${data_center_name}
        private: true
    - hostname
    - virtual_machine_name
    - virtualMachineName:
        default: ${get("virtual_machine_name", None)}
        private: true
        required: false
    - clone_name
    - cloneName:
        default: ${get("clone_name", None)}
        private: true
        required: false
    - folder_name:
        required: false
    - folderName:
        default: ${get("folder_name", "")}
        private: true
        required: false
    - clone_host:
        required: false
    - cloneHost:
        default: ${get("clone_host", "")}
        private: true
        required: false
    - clone_resource_pool:
        required: false
    - cloneResourcePool:
        default: ${get("clone_resource_pool", "")}
        private: true
        required: false
    - clone_data_store:
        required: false
    - cloneDataStore:
        default: ${get("clone_data_store", "")}
        private: true
        required: false
    - thick_provision:
        required: false
    - thickProvision:
        default: ${get("thick_provision", "false")}
        private: true
    - is_template:
        required: false
    - isTemplate:
        default: ${get("is_template", "false")}
        private: true
    - num_cpus:
        required: false
    - cpuNum:
        default: ${get("num_cpus", "1")}
        private: true
    - cores_per_socket:
        required: false
    - coresPerSocket:
        default: ${get("cores_per_socket", "1")}
        private: true
    - memory:
        default: '1024'
        required: false
    - clone_description:
        required: false
    - cloneDescription:
        default: ${get("clone_description", "")}
        private: true
        required: false

  java_action:
    gav: 'io.cloudslang.content:score-vmware:0.0.4'
    class_name: io.cloudslang.content.vmware.actions.vm.CloneVM
    method_name: cloneVM

  outputs:
    - return_result: ${get("returnResult", "")}
    - error_message: ${get("exception", returnResult if returnCode != '0' else '')}
    - return_code: ${returnCode}

  results:
    - SUCCESS : ${returnCode == '0'}
    - FAILURE

#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Performs a VMware vSphere command in order to clone an existing virtual machine.
#!
#! @prerequisites: vim25.jar
#!   How to obtain the vim25.jar:
#!     1. Go to https://my.vmware.com/web/vmware and register.
#!     2. Go to https://my.vmware.com/group/vmware/get-download?downloadGroup=MNGMTSDK600
#!        and download the VMware-vSphere-SDK-6.0.0-2561048.zip.
#!     3. Locate the vim25.jar in ../VMware-vSphere-SDK-6.0.0-2561048/SDK/vsphere-ws/java/JAXWS/lib.
#!     4. Copy the vim25.jar into the ClodSlang CLI folder under /cslang/lib.
#!
#! @input host: VMware host or IP.
#!              Example: 'vc6.subdomain.example.com'
#! @input port: Port to connect through.
#!              Optional
#!              Examples: '443', '80'
#!              Default: '443'
#! @input protocol: Connection protocol.
#!                  Optional
#!                  Valid: 'http', 'https'
#!                  Default: 'https'
#! @input username: VMware username to connect with.
#! @input password: Password associated with <username> input.
#! @input trust_everyone: If 'True', will allow connections from any host, if 'False', connection will be
#!                        allowed only using a valid vCenter certificate
#!                        Check https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_java_development.4.3.html
#!                        to see how to import a certificate into Java Keystore and
#!                        https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_sg_server_certificate_Appendix.6.4.html
#!                        to see how to obtain a valid vCenter certificate.
#!                        Default: 'true'
#! @input data_center_name: Data center name where host system is.
#!                          Example: 'DataCenter2'
#! @input hostname: Name of target host to be queried to retrieve supported guest OSes.
#!                  Example: 'host123.subdomain.example.com'
#! @input virtual_machine_name: Name of virtual machine that will be cloned.
#! @input clone_name: name that Will be assigned to the cloned virtual machine.
#! @input folder_name: Name of the folder where the cloned virtual machine will reside.
#!                     If not provided then the top parent folder will be used.
#!                     Default: ''
#!                     Optional
#! @input clone_host: The host for the cloned virtual machine.
#!                    If not provided then the same host of the virtual machine that will be cloned will be used.
#!                    Example: 'host123.subdomain.example.com'
#!                    Default: ''
#!                    Optional
#! @input clone_resource_pool: The resource pool for the cloned virtual machine.
#!                             If not provided then the parent resource pool will be used.
#!                             Default: ''
#!                             Optional
#! @input clone_data_store: Datastore where disk of newly cloned virtual machine will reside.
#!                          If not provided then the datastore of the cloned virtual machine will be used.
#!                          Example: 'datastore2-vc6-1'
#!                          Default: ''
#!                          Optional
#! @input thick_provision: Whether the provisioning of the cloned virtual machine will be thick or not.
#!                         Default: 'false'
#!                         Optional
#! @input is_template: Whether the cloned virtual machine will be a template or not.
#!                     Default: 'false'
#!                     Optional
#! @input num_cpus: Number that indicates how many processors the newly cloned virtual machine will have.
#!                  Default: '1'
#!                  Optional
#! @input cores_per_socket: Number that indicates how many cores per socket the newly cloned virtual machine will have.
#!                          Default: '1'
#!                          Optional
#! @input memory: Amount of memory (in Mb) attached to cloned virtual machined.
#!                Default: '1024'
#!                Optional
#! @input clone_description: Description of virtual machine that will be cloned.
#!                           Default: ''
#!                           Optional
#!
#! @output return_result: Contains the exception in case of failure, success message otherwise.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output error_message: Error message if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: Virtual machine was successfully cloned.
#! @result FAILURE: An error occurred when trying to clone an existing virtual machine.
#!!#
########################################################################################################################

namespace: io.cloudslang.vmware.vcenter.virtual_machines

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
        default: ${get("virtual_machine_name", "")}
        private: true
        required: false
    - clone_name
    - cloneName:
        default: ${get("clone_name", "")}
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
    gav: 'io.cloudslang.content:cs-vmware:0.0.21'
    class_name: io.cloudslang.content.vmware.actions.vm.CloneVM
    method_name: cloneVM

  outputs:
    - return_result: ${get("returnResult", "")}
    - error_message: ${get("exception", returnResult if returnCode != '0' else '')}
    - return_code: ${returnCode}

  results:
    - SUCCESS : ${returnCode == '0'}
    - FAILURE

#   (c) Copyright 2017 EntIT Software LLC, a Micro Focus company, L.P.
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
###################################################################################################
#!!
#! @description: Performs a complete virtual machine lifecycle (Create-Read-Update-Delete scenario) against a VMware data
#!   center using vSphere commands.
#!
#! @prerequisites: vim25.jar
#!   How to obtain the vim25.jar:
#!     1. Go to https://my.vmware.com/web/vmware and register.
#!     2. Go to https://my.vmware.com/group/vmware/get-download?downloadGroup=MNGMTSDK600 and download the VMware-vSphere-SDK-6.0.0-2561048.zip.
#!     3. Locate the vim25.jar in ../VMware-vSphere-SDK-6.0.0-2561048/SDK/vsphere-ws/java/JAXWS/lib.
#!     4. Copy the vim25.jar into the ClodSlang CLI folder under /cslang/lib.
#!
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
#! @input password: password associated with <username>
#! @input trust_everyone: if 'True', will allow connections from any host, if 'False', connection will be
#!                        allowed only using a valid vCenter certificate
#!                        optional
#!                        default: True
#!                        Check https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_java_development.4.3.html
#!                        to see how to import a certificate into Java Keystore and
#!                        https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_sg_server_certificate_Appendix.6.4.html
#!                        to see how to obtain a valid vCenter certificate.
#! @input data_center_name: virtual machine's data center name
#!                          example: 'DataCenter2'
#! @input hostname: name of host where newly created virtual machine will reside
#!                  optional
#!                  example: 'host123.subdomain.example.com'
#!                  default: ''
#! @input virtual_machine_name: name of virtual machine that will be created
#! @input data_store: datastore where disk of the newly created virtual machine will reside
#!                    example: 'datastore2-vc6-1'
#! @input guest_os_id: operating system associated with newly created virtual machine; value for this input can
#!                     be obtained by running utils/get_os_descriptors operation
#!                     examples: 'winXPProGuest', 'win95Guest', 'centosGuest', 'fedoraGuest', 'freebsd64Guest'...
#! @input folder_name: name of the folder where the virtual machine will be created. If not provided then the top parent
#!                     folder will be used
#!                     optional
#!                     default: ''
#! @input resource_pool: The resource pool for the cloned virtual machine. If not provided then the parent resource pool
#!                       will be used
#!                       optional
#!                       default: ''
#! @input description: description of virtual machine that will be created
#!                     optional
#!                     default: ''
#! @input num_cpus: number that indicates how many processors the newly created virtual machine will have
#!                  optional
#!                  default: '1'
#! @input vm_disk_size: disk capacity (in Mb) attached to virtual machine that will be created
#!                      optional
#!                      default: '1024'
#! @input vm_memory_size: amount of memory (in Mb) attached to virtual machine that will be created
#!                        optional
#!                        default: '1024'
#! @input operation: possible operations that can be applied to update a specified attached device ("update" operation
#!                   is only possible for cpu and memory, "add", "remove" are not allowed for cpu and memory devices)
#!                   valid: "add", "remove", "update"
#! @input device: device on which update operation will be applied
#!                valid values: "cpu", "memory", "disk", "cd", "nic"
#! @input update_value: value applied on specified device during virtual machine update
#!                      valid: "high", "low", "normal", numeric value, label of device when removing
#! @input vm_disk_mode: property that specifies how disk will be attached to the virtual machine
#!                      optional
#!                      valid: "persistent", "independent_persistent", "independent_nonpersistent"
#!                      This input will be considered only when "add" operation and "disk" device are provided.
#! @input linux_oses: list/array of Linux OSs supported by <hostname> host
#!                    optional
#!                    example: ['ubuntu64Guest']
#! @input delimiter: delimiter that will be used in response list
#!                   default: ','
#! @input email_host: email host
#! @input email_port: email port
#! @input email_username: email username
#! @input email_password: email password
#! @input email_sender: email sender
#! @input email_recipient: email recipient
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: virtual machine was successfully created
#! @result FAILURE: An error occurred when trying to create a new virtual machine
#!!#
########################################################################################################################

namespace: io.cloudslang.vmware.vcenter.samples

imports:
  samples: io.cloudslang.vmware.vcenter.samples
  lists: io.cloudslang.base.lists

flow:
  name: test_virtual_machine_lifecycle

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
    - data_center_name
    - hostname
    - virtual_machine_name
    - data_store
    - guest_os_id: 'ubuntu64Guest'
    - folder_name:
        default: ''
        required: false
    - resource_pool:
        default: ''
        required: false
    - description:
        default: ''
        required: false
    - num_cpus:
        default: '1'
        required: false
    - vm_disk_size:
        default: '1024'
        required: false
    - vm_memory_size:
        default: '1024'
        required: false
    - operation: 'add'
    - device: 'disk'
    - update_value:
        default: ''
        required: false
    - vm_disk_mode: 'persistent'
    - delimiter:
        default: ','
        required: false
    - email_host
    - email_port
    - email_username
    - email_password
    - email_sender
    - email_recipient

  workflow:
    - virtual_machine_lifecycle:
        do:
          samples.virtual_machine_lifecycle:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - data_center_name
            - hostname
            - virtual_machine_name
            - data_store
            - guest_os_id
            - folder_name
            - resource_pool
            - description
            - num_cpus
            - vm_disk_size
            - vm_memory_size
            - operation
            - device
            - update_value
            - vm_disk_mode
            - linux_oses
            - delimiter
            - email_host
            - email_port
            - email_username
            - email_password
            - email_sender
            - email_recipient
        publish:
          - return_result
          - return_code
          - exception: ${get("exception", '')}
        navigate:
          - SUCCESS: check_result
          - GET_OS_DESCRIPTORS_FAILURE: GET_OS_DESCRIPTORS_FAILURE
          - SEND_OSES_SUPPORTED_LIST_MAIL_FAILURE: SEND_OSES_SUPPORTED_LIST_MAIL_FAILURE
          - GUEST_OS_ID_NOT_FOUND: GUEST_OS_ID_NOT_FOUND
          - CREATE_VIRTUAL_MACHINE_FAILURE: CREATE_VIRTUAL_MACHINE_FAILURE
          - GET_CREATED_TEXT_OCCURRENCE_FAILURE: GET_CREATED_TEXT_OCCURRENCE_FAILURE
          - LIST_VMS_FAILURE: LIST_VMS_FAILURE
          - VM_NOT_FOUND: VM_NOT_FOUND
          - GET_CREATED_VM_DETAILS_FAILURE: GET_CREATED_VM_DETAILS_FAILURE
          - SEND_CREATED_VM_MAIL_FAILURE: SEND_CREATED_VM_MAIL_FAILURE
          - GET_VALUE_BEFORE_UPDATE_FAILURE: GET_VALUE_BEFORE_UPDATE_FAILURE
          - UPDATE_VM_FAILURE: UPDATE_VM_FAILURE
          - GET_UPDATED_VM_DETAILS_FAILURE: GET_UPDATED_VM_DETAILS_FAILURE
          - GET_VALUE_AFTER_UPDATE_FAILURE: GET_VALUE_AFTER_UPDATE_FAILURE
          - SEND_UPDATED_VM_MAIL_FAILURE: SEND_UPDATED_VM_MAIL_FAILURE
          - POWER_ON_VM_FAILURE: POWER_ON_VM_FAILURE
          - NOT_POWERED_ON: NOT_POWERED_ON
          - SEND_POWERED_ON_VM_MAIL_FAILURE: SEND_POWERED_ON_VM_MAIL_FAILURE
          - POWER_OFF_VM_FAILURE: POWER_OFF_VM_FAILURE
          - NOT_POWERED_OFF: NOT_POWERED_OFF
          - SEND_POWERED_OFF_VM_MAIL_FAILURE: SEND_POWERED_OFF_VM_MAIL_FAILURE
          - DELETE_VM_FAILURE: DELETE_VM_FAILURE
          - SECOND_LIST_VMS_FAILURE: SECOND_LIST_VMS_FAILURE
          - NOT_DELETED: NOT_DELETED
          - SEND_DELETE_VM_MAIL_FAILURE: SEND_DELETE_VM_MAIL_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(exception) + "," + return_code}
            - list_2: ",0"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULT_FAILURE

  outputs:
    - return_result
    - return_code
    - exception
    - before_update_value
    - after_update_value

  results:
    - SUCCESS
    - GET_OS_DESCRIPTORS_FAILURE
    - SEND_OSES_SUPPORTED_LIST_MAIL_FAILURE
    - GUEST_OS_ID_NOT_FOUND
    - CREATE_VIRTUAL_MACHINE_FAILURE
    - GET_CREATED_TEXT_OCCURRENCE_FAILURE
    - LIST_VMS_FAILURE
    - VM_NOT_FOUND
    - GET_CREATED_VM_DETAILS_FAILURE
    - SEND_CREATED_VM_MAIL_FAILURE
    - GET_VALUE_BEFORE_UPDATE_FAILURE
    - UPDATE_VM_FAILURE
    - GET_UPDATED_VM_DETAILS_FAILURE
    - GET_VALUE_AFTER_UPDATE_FAILURE
    - SEND_UPDATED_VM_MAIL_FAILURE
    - POWER_ON_VM_FAILURE
    - NOT_POWERED_ON
    - SEND_POWERED_ON_VM_MAIL_FAILURE
    - POWER_OFF_VM_FAILURE
    - NOT_POWERED_OFF
    - SEND_POWERED_OFF_VM_MAIL_FAILURE
    - DELETE_VM_FAILURE
    - SECOND_LIST_VMS_FAILURE
    - NOT_DELETED
    - SEND_DELETE_VM_MAIL_FAILURE
    - CHECK_RESULT_FAILURE

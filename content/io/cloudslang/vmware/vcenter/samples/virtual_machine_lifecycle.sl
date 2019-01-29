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
########################################################################################################################
#!!
#! @description: Performs a complete virtual machine lifecycle (Create-Read-Update-Delete scenario) against a VMware data center
#!   using vSphere commands.
#!
#! @prerequisites: vim25.jar
#!   How to obtain the vim25.jar:
#!     1. Go to https://my.vmware.com/web/vmware and register.
#!     2. Go to https://my.vmware.com/group/vmware/get-download?downloadGroup=MNGMTSDK600
#!        and download the VMware-vSphere-SDK-6.0.0-2561048.zip.
#!     3. Locate the vim25.jar in ../VMware-vSphere-SDK-6.0.0-2561048/SDK/vsphere-ws/java/JAXWS/lib.
#!     4. Copy the vim25.jar into the ClodSlang CLI folder under /cslang/lib.
#!
#!
#! @input host: VMware host or IP.
#!              example: 'vc6.subdomain.example.com'
#! @input port: Port to connect through.
#!              Examples: '443', '80'
#!              Default: '443'
#!              Optional
#! @input protocol: Connection protocol.
#!                  Valid: 'http', 'https'
#!                  Default: 'https'
#!                  Optional
#! @input username: VMware username to connect with.
#! @input password: Password associated with <username>.
#! @input trust_everyone: If 'true', will allow connections from any host, if 'false', connection will be
#!                        allowed only using a valid vCenter certificate.
#!                        Check https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_java_development.4.3.html
#!                        to see how to import a certificate into Java Keystore and
#!                        https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_sg_server_certificate_Appendix.6.4.html
#!                        to see how to obtain a valid vCenter certificate.
#!                        Default: 'true'
#!                        Optional
#! @input data_center_name: Virtual machine's data center name.
#!                          Example: 'DataCenter2'
#! @input hostname: Name of host where newly created virtual machine will reside.
#!                  example: 'host123.subdomain.example.com'
#! @input virtual_machine_name: Name of virtual machine that will be created.
#! @input data_store: Datastore where disk of the newly created virtual machine will reside.
#!                    Example: 'datastore2-vc6-1'
#! @input guest_os_id: Operating system associated with newly created virtual machine; value for this input can
#!                     be obtained by running utils/get_os_descriptors operation.
#!                     examples: 'winXPProGuest', 'win95Guest', 'centosGuest', 'fedoraGuest', 'freebsd64Guest'
#!                     Default: 'ubuntu64Guest'
#!                     Optional
#! @input folder_name: Name of the folder where the virtual machine will be created.
#!                     If not provided then the top parent folder will be used.
#!                     Default: ''
#!                     Optional
#! @input resource_pool: The resource pool for the cloned virtual machine.
#!                       If not provided then the parent resource pool will be used.
#!                       Default: ''
#!                       Optional
#! @input description: Description of virtual machine that will be created.
#!                     Default: ''
#!                     Optional
#! @input num_cpus: Number that indicates how many processors the newly created virtual machine will have.
#!                  Default: '1'
#!                  Optional
#! @input vm_disk_size: Disk capacity (in Mb) attached to virtual machine that will be created.
#!                      Default: '1024'
#!                      Optional
#! @input vm_memory_size: Amount of memory (in Mb) attached to virtual machine that will be created
#!                        Default: '1024'
#!                        Optional
#! @input operation: Possible operations that can be applied to update a specified attached device ("update" operation
#!                   is only possible for cpu and memory, "add", "remove" are not allowed for cpu and memory devices)
#!                   Valid: "add", "remove", "update"
#! @input device: Device on which update operation will be applied
#!                Valid values: "cpu", "memory", "disk", "cd", "nic"
#! @input update_value: value applied on specified device during virtual machine update.
#!                      Valid: "high", "low", "normal", numeric value, label of device when removing
#!                      Optional
#! @input vm_disk_mode: Property that specifies how disk will be attached to the virtual machine
#!                      This input will be considered only when "add" operation and "disk" device are provided.
#!                      Valid: "persistent", "independent_persistent", "independent_nonpersistent"
#!                      Default: 'persistent'
#!                      Optional
#! @input delimiter: Delimiter that will be used in response list.
#!                   Default: ','
#!                   Optional
#! @input email_host: Email host.
#! @input email_port: Email port.
#! @input email_username: Email username.
#! @input email_password: Email password.
#! @input email_sender: Email sender.
#! @input email_recipient: Email recipient.
#!
#! @output return_result: Contains the exception in case of failure, success message otherwise.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output before_update_value: Value of specific machine attribute before update.
#! @output after_update_value: Value of specific machine attribute after update.
#!
#! @result SUCCESS: Virtual machine was successfully created.
#! @result GET_OS_DESCRIPTORS_FAILURE: There was an error while trying to get OS information.
#! @result SEND_OSES_SUPPORTED_LIST_MAIL_FAILURE: There was an error while sending an email with the OSes list.
#! @result GUEST_OS_ID_NOT_FOUND: There was an error while retrieving the guest OS ID.
#! @result CREATE_VIRTUAL_MACHINE_FAILURE: There was an error while trying to create the virtual machine.
#! @result GET_CREATED_TEXT_OCCURRENCE_FAILURE: There was an error while retrieving the created text occurrence.
#! @result LIST_VMS_FAILURE: There was an error while listing the virtual machines.
#! @result VM_NOT_FOUND: There was an error finding a virtual machine.
#! @result GET_CREATED_VM_DETAILS_FAILURE: There was an error while retrieving the VM details.
#! @result SEND_CREATED_VM_MAIL_FAILURE: There was an error while trying to send an email with the VM details.
#! @result GET_VALUE_BEFORE_UPDATE_FAILURE: There was an error while retrieving the value before update.
#! @result UPDATE_VM_FAILURE: There was an error while updating the virtual machine.
#! @result GET_UPDATED_VM_DETAILS_FAILURE: There was an error while retrieving the updated VM details.
#! @result GET_VALUE_AFTER_UPDATE_FAILURE: There was an error while retrieving the value after the update.
#! @result SEND_UPDATED_VM_MAIL_FAILURE: There was an error while sending an email with the updated VM details.
#! @result POWER_ON_VM_FAILURE: There was an error while powering on the virtual machine.
#! @result NOT_POWERED_ON: The virtual machine is not powered on.
#! @result SEND_POWERED_ON_VM_MAIL_FAILURE: There was an error while trying to send an email about the VM power on state.
#! @result POWER_OFF_VM_FAILURE: There was an error while powering off the virtual machine.
#! @result NOT_POWERED_OFF: The virtual machine is not powered off.
#! @result SEND_POWERED_OFF_VM_MAIL_FAILURE: There was an error while trying to send an email about the VM power off state.
#! @result DELETE_VM_FAILURE: There was an error while deleting the virtual machine.
#! @result SECOND_LIST_VMS_FAILURE: There was an error while listing the second virtual machines list.
#! @result NOT_DELETED: The virtual machine not deleted.
#! @result SEND_DELETE_VM_MAIL_FAILURE: There was an error while trying to send an email about the VM deleted list.
#!!#
########################################################################################################################

namespace: io.cloudslang.vmware.vcenter.samples

imports:
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  vms: io.cloudslang.vmware.vcenter.virtual_machines
  utils: io.cloudslang.vmware.vcenter.utils
  mail: io.cloudslang.base.mail

flow:
  name: virtual_machine_lifecycle

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
        default: 'true'
        required: false
    - data_center_name
    - hostname
    - virtual_machine_name
    - data_store
    - guest_os_id:
        default: 'ubuntu64Guest'
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
    - operation:
        default: 'add'
        required: false
    - device:
        required: false
        default: 'disk'
    - update_value:
        default: ''
        required: false
    - vm_disk_mode:
        default: 'persistent'
        required: false
    - delimiter:
        default: ','
        required: false
    - email_host
    - email_port
    - email_username
    - email_password:
        sensitive: true
    - email_sender
    - email_recipient

  workflow:
    - get_oses_list:
        do:
          utils.get_os_descriptors:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - data_center_name
            - hostname
            - delimiter
        publish:
          - return_result
          - return_code
          - exception: ${exception if exception != None else ''}
        navigate:
          - SUCCESS: supported_oses_list_mail
          - FAILURE: GET_OS_DESCRIPTORS_FAILURE

    - supported_oses_list_mail:
        do:
          mail.send_mail:
            - host: ${hostname}
            - hostname: ${ email_host }
            - port: ${ email_port }
            - username: ${ email_username }
            - password: ${ email_password }
            - html_email: "false"
            - from: ${ email_sender }
            - to: ${ email_recipient }
            - subject: "${'Successfully retrieved supported guest OSes list for: [' + host + '] VMware host.'}"
            - body: >
                ${'List of all supported guest OSes:\n\n ' + return_result}
        navigate:
          - SUCCESS: get_guest_os_id_occurrence
          - FAILURE: SEND_OSES_SUPPORTED_LIST_MAIL_FAILURE

    - get_guest_os_id_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: ${guest_os_id}
            - ignore_case: 'true'
        navigate:
          - SUCCESS: create_vm
          - FAILURE: GUEST_OS_ID_NOT_FOUND

    - create_vm:
        do:
          vms.create_virtual_machine:
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
        publish:
          - return_result
          - return_code
          - exception: ${exception if exception != None else ''}
        navigate:
          - SUCCESS: get_created_text_occurrence
          - FAILURE: CREATE_VIRTUAL_MACHINE_FAILURE

    - get_created_text_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: "${'Success: Created'}"
            - ignore_case: 'true'
        navigate:
          - SUCCESS: list_all_vms
          - FAILURE: GET_CREATED_TEXT_OCCURRENCE_FAILURE

    - list_all_vms:
        do:
          vms.list_virtual_machines_and_templates:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - delimiter
        publish:
          - return_result
          - return_code
          - exception: ${exception if exception != None else ''}
        navigate:
          - SUCCESS: get_vm_occurrence
          - FAILURE: LIST_VMS_FAILURE

    - get_vm_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: ${virtual_machine_name}
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_created_vm_details
          - FAILURE: VM_NOT_FOUND

    - get_created_vm_details:
        do:
          vms.get_virtual_machine_details:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - hostname
            - virtual_machine_name
            - delimiter
        publish:
          - return_result
          - return_code
          - exception: ${exception if exception != None else ''}
        navigate:
          - SUCCESS: create_vm_mail
          - FAILURE: GET_CREATED_VM_DETAILS_FAILURE

    - create_vm_mail:
        do:
          mail.send_mail:
            - hostname: ${ email_host }
            - port: ${ email_port }
            - username: ${ email_username }
            - password: ${ email_password }
            - html_email: "false"
            - from: ${ email_sender }
            - to: ${ email_recipient }
            - subject: "${'Successfully created: [' + virtual_machine_name + '] virtual machine.'}"
            - body: >
                ${'The virtual machine [' + virtual_machine_name + '] details are:\n\n ' + return_result}
        navigate:
          - SUCCESS: get_created_disk_number
          - FAILURE: SEND_CREATED_VM_MAIL_FAILURE

    - get_created_disk_number:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "numDisks"
        publish:
          - before_update_value: ${return_result}
        navigate:
          - SUCCESS: update_vm
          - FAILURE: GET_VALUE_BEFORE_UPDATE_FAILURE

    - update_vm:
        do:
          vms.update_virtual_machine:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - virtual_machine_name
            - operation
            - device
            - vm_disk_size
            - vm_disk_mode
        publish:
          - return_result
          - return_code
          - exception: ${exception if exception != None else ''}
        navigate:
          - SUCCESS: get_updated_vm_details
          - FAILURE: UPDATE_VM_FAILURE

    - get_updated_vm_details:
        do:
          vms.get_virtual_machine_details:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - hostname
            - virtual_machine_name
            - delimiter
        publish:
          - return_result
          - return_code
          - exception: ${exception if exception != None else ''}
        navigate:
          - SUCCESS: get_updated_disk_number
          - FAILURE: GET_UPDATED_VM_DETAILS_FAILURE

    - get_updated_disk_number:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "numDisks"
        publish:
          - after_update_value: ${return_result}
        navigate:
          - SUCCESS: update_vm_mail
          - FAILURE: GET_VALUE_AFTER_UPDATE_FAILURE

    - update_vm_mail:
        do:
          mail.send_mail:
            - hostname: ${ email_host }
            - port: ${ email_port }
            - username: ${ email_username }
            - password: ${ email_password }
            - html_email: "false"
            - from: ${ email_sender }
            - to: ${ email_recipient }
            - subject: "${'Successfully updated: [' + virtual_machine_name + '] virtual machine.'}"
            - body: >
                ${'Updated [' + device + '] on [' + virtual_machine_name + '] virtual machine using [' + operation
                + '] operation ' +  ' from [' + before_update_value + '] value to [' + after_update_value
                + '] value.\n\n The virtual machine [' + virtual_machine_name + '] details are now:\n ' + return_result}
        navigate:
          - SUCCESS: power_on_vm
          - FAILURE: SEND_UPDATED_VM_MAIL_FAILURE

    - power_on_vm:
        do:
          vms.power_on_virtual_machine:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - virtual_machine_name
        publish:
          - return_result
          - return_code
          - exception: ${exception if exception != None else ''}
        navigate:
          - SUCCESS: is_vm_powered_on
          - FAILURE: POWER_ON_VM_FAILURE

    - is_vm_powered_on:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: "${'successfully powered on'}"
            - ignore_case: "true"
        navigate:
          - SUCCESS: powered_on_vm_mail
          - FAILURE: NOT_POWERED_ON

    - powered_on_vm_mail:
        do:
          mail.send_mail:
            - hostname: ${ email_host }
            - port: ${ email_port }
            - username: ${ email_username }
            - password: ${ email_password }
            - html_email: "false"
            - from: ${ email_sender }
            - to: ${ email_recipient }
            - subject: "${'Successfully powered on: [' + virtual_machine_name + '] virtual machine.'}"
            - body: ${return_result}
        navigate:
          - SUCCESS: power_off_vm
          - FAILURE: SEND_POWERED_ON_VM_MAIL_FAILURE

    - power_off_vm:
        do:
          vms.power_off_virtual_machine:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - virtual_machine_name
        publish:
          - return_result
          - return_code
          - exception: ${exception if exception != None else ''}
        navigate:
          - SUCCESS: is_vm_powered_off
          - FAILURE: POWER_OFF_VM_FAILURE

    - is_vm_powered_off:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: "${'successfully powered off'}"
            - ignore_case: "true"
        navigate:
          - SUCCESS: powered_off_vm_mail
          - FAILURE: NOT_POWERED_OFF

    - powered_off_vm_mail:
        do:
          mail.send_mail:
            - hostname: ${ email_host }
            - port: ${ email_port }
            - username: ${ email_username }
            - password: ${ email_password }
            - html_email: "false"
            - from: ${ email_sender }
            - to: ${ email_recipient }
            - subject: "${'Successfully powered off: [' + virtual_machine_name + '] virtual machine.'}"
            - body: ${return_result}
        navigate:
          - SUCCESS: delete_vm
          - FAILURE: SEND_POWERED_OFF_VM_MAIL_FAILURE

    - delete_vm:
        do:
          vms.delete_virtual_machine:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - virtual_machine_name
        publish:
          - return_result
          - return_code
          - exception: ${exception if exception != None else ''}
        navigate:
          - SUCCESS: second_list_all_vms
          - FAILURE: DELETE_VM_FAILURE

    - second_list_all_vms:
        do:
          vms.list_virtual_machines_and_templates:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - delimiter
        publish:
          - return_result
          - return_code
          - exception: ${exception if exception != None else ''}
        navigate:
          - SUCCESS: second_get_vm_occurrence
          - FAILURE: SECOND_LIST_VMS_FAILURE

    - second_get_vm_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: ${virtual_machine_name}
            - ignore_case: "true"
        navigate:
          - SUCCESS: NOT_DELETED
          - FAILURE: delete_vm_mail

    - delete_vm_mail:
        do:
          mail.send_mail:
            - hostname: ${ email_host }
            - port: ${ email_port }
            - username: ${ email_username }
            - password: ${ email_password }
            - html_email: "false"
            - from: ${ email_sender }
            - to: ${ email_recipient }
            - subject: "${'Successfully deleted: [' + virtual_machine_name + '] virtual machine.'}"
            - body: >
                ${'The list with all remaining virtual machines and templates in [' + data_center_name + '] are:\n\n'
                + return_result}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SEND_DELETE_VM_MAIL_FAILURE

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

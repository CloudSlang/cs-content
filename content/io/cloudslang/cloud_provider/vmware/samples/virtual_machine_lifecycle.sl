#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
########################################################################################################################
# Performs a complete virtual machine lifecycle (Create-Read-Update-Delete scenario) against a VMware data center
#   using vSphere commands
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
#   - data_center_name - the virtual machine's data center name - Example: 'DataCenter2'
#   - hostname - optional - the name of the host where the new created virtual machine will reside
#                         - Example: 'host123.subdomain.example.com' - Default: ''
#   - virtual_machine_name - the name of the virtual machine that will be created
#   - description - optional - the description of the virtual machine that will be created - Default: ''
#   - data_store - the datastore where the disk of the new created virtual machine will reside - Example: 'datastore2-vc6-1'
#   - num_cpus - optional - the number that indicates how many processors will have the virtual machine that will be created
#                        - Default: '1'
#   - vm_disk_size - optional - the disk capacity amount (in Mb) attached to the virtual machine that will be created
#                           - Default: '1024'
#   - vm_memory_size - optional - the memory amount (in Mb) attached to the virtual machine that will be createdm
#                             - Default: '1024'
#   - guest_os_id - the operating system associated with the new created virtual machine. The value for this input can
#                   be obtained by running utils/get_os_descriptors operation - Examples: 'ubuntu64Guest'
#   - operation - the possible operations that can be applied to update a specified attached device ("update" operation
#                 is only possible for cpu and memory, "add", "remove" are not allowed for cpu and memory devices)
#                 Valid values: "add", "remove", "update"
#   - device - the device on which the update operation will be applied - Valid values: "cpu", "memory", "disk", "cd",
#              "nic"
#   - update_value - the value applied on the specified device during the virtual machine update - Valid values: "high",
#                   "low", "normal", numeric value, label of device when removing
#   - vm_disk_mode - optional - the property that specifies how the disk will be attached to the virtual machine
#                             - Valid values: "persistent", "independent_persistent", "independent_nonpersistent"
#                               This input will be considered only when "add" operation and "disk" device are provided
#   - linux_oses - optional - list/array of linux OSes supported by <hostname> host - Example: ['ubuntu64Guest']
#   - delimiter - the delimiter that will be used in response list - Default: ','
#   - email_host
#   - email_port
#   - email_username
#   - email_password
#   - email_sender
#   - email_recipient
#
# Outputs:
#   - return_result - contains the exception in case of failure, success message otherwise
#   - return_code - '0' if operation was successfully executed, '-1' otherwise
#   - error_message - error message if there was an error when executing, empty otherwise
# Results:
#   - SUCCESS: the virtual machine was successfully created
#   - FAILURE: an error occurred when trying to create a new virtual machine
########################################################################################################################

namespace: io.cloudslang.cloud_provider.vmware.samples

imports:
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  vms: io.cloudslang.cloud_provider.vmware.virtual_machines
  utils: io.cloudslang.cloud_provider.vmware.utils
  base_mail: io.cloudslang.base.mail

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
    - username:
        required: false
    - password
    - trust_everyone:
        default: 'true'
        required: false
    - data_center_name
    - hostname
    - virtual_machine_name
    - description:
        default: ''
        required: false
    - data_store
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
    - guest_os_id: 'ubuntu64Guest'
    - linux_oses:
        default: ['ubuntu64Guest']
        required: false
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
          - exception : ${exception if exception != None else ''}
        navigate:
          SUCCESS: supported_oses_list_mail
          FAILURE: GET_OS_DESCRIPTORS_FAILURE

    - supported_oses_list_mail:
        do:
          base_mail.send_mail:
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
          SUCCESS: get_guest_os_id_occurrence
          FAILURE: SEND_OSES_SUPPORTED_LIST_MAIL_FAILURE

    - get_guest_os_id_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: ${guest_os_id}
            - ignore_case: True
        navigate:
          SUCCESS: create_vm
          FAILURE: GUEST_OS_ID_NOT_FOUND

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
            - description
            - data_store
            - num_cpus
            - vm_disk_size
            - vm_memory_size
            - guest_os_id
        publish:
          - return_result
          - return_code
          - exception : ${exception if exception != None else ''}
        navigate:
          SUCCESS: get_created_text_occurrence
          FAILURE: CREATE_VIRTUAL_MACHINE_FAILURE

    - get_created_text_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: "${'Success: Created'}"
            - ignore_case: True
        navigate:
          SUCCESS: list_all_vms
          FAILURE: GET_CREATED_TEXT_OCCURRENCE_FAILURE

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
          - exception : ${exception if exception != None else ''}
        navigate:
          SUCCESS: get_vm_occurrence
          FAILURE: LIST_VMS_FAILURE

    - get_vm_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: ${virtual_machine_name}
            - ignore_case: True
        navigate:
          SUCCESS: get_created_vm_details
          FAILURE: VM_NOT_FOUND

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
          - exception : ${exception if exception != None else ''}
        navigate:
          SUCCESS: create_vm_mail
          FAILURE: GET_CREATED_VM_DETAILS_FAILURE

    - create_vm_mail:
        do:
          base_mail.send_mail:
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
          SUCCESS: get_created_disk_number
          FAILURE: SEND_CREATED_VM_MAIL_FAILURE

    - get_created_disk_number:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['numDisks']
        publish:
          - before_update_value: ${value}
        navigate:
          SUCCESS: update_vm
          FAILURE: GET_VALUE_BEFORE_UPDATE_FAILURE

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
          - exception : ${exception if exception != None else ''}
        navigate:
          SUCCESS: get_updated_vm_details
          FAILURE: UPDATE_VM_FAILURE

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
          - exception : ${exception if exception != None else ''}
        navigate:
          SUCCESS: get_updated_disk_number
          FAILURE: GET_UPDATED_VM_DETAILS_FAILURE

    - get_updated_disk_number:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['numDisks']
        publish:
          - after_update_value: ${value}
        navigate:
          SUCCESS: update_vm_mail
          FAILURE: GET_VALUE_AFTER_UPDATE_FAILURE

    - update_vm_mail:
        do:
          base_mail.send_mail:
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
          SUCCESS: power_on_vm
          FAILURE: SEND_UPDATED_VM_MAIL_FAILURE

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
          - exception : ${exception if exception != None else ''}
        navigate:
          SUCCESS: is_vm_powered_on
          FAILURE: POWER_ON_VM_FAILURE

    - is_vm_powered_on:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: "${'successfully powered on'}"
            - ignore_case: True
        navigate:
          SUCCESS: powered_on_vm_mail
          FAILURE: NOT_POWERED_ON

    - powered_on_vm_mail:
        do:
          base_mail.send_mail:
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
          SUCCESS: power_off_vm
          FAILURE: SEND_POWERED_ON_VM_MAIL_FAILURE

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
          - exception : ${exception if exception != None else ''}
        navigate:
          SUCCESS: is_vm_powered_off
          FAILURE: POWER_OFF_VM_FAILURE

    - is_vm_powered_off:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: "${'successfully powered off'}"
            - ignore_case: True
        navigate:
          SUCCESS: powered_off_vm_mail
          FAILURE: NOT_POWERED_OFF

    - powered_off_vm_mail:
        do:
          base_mail.send_mail:
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
          SUCCESS: delete_vm
          FAILURE: SEND_POWERED_OFF_VM_MAIL_FAILURE

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
          - exception : ${exception if exception != None else ''}
        navigate:
          SUCCESS: second_list_all_vms
          FAILURE: DELETE_VM_FAILURE

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
          - exception : ${exception if exception != None else ''}
        navigate:
          SUCCESS: second_get_vm_occurrence
          FAILURE: SECOND_LIST_VMS_FAILURE

    - second_get_vm_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: ${virtual_machine_name}
            - ignore_case: True
        navigate:
          SUCCESS: NOT_DELETED
          FAILURE: delete_vm_mail

    - delete_vm_mail:
        do:
          base_mail.send_mail:
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
          SUCCESS: SUCCESS
          FAILURE: SEND_DELETE_VM_MAIL_FAILURE

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
    - ADD_DISK_ON_VM_FAILURE
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
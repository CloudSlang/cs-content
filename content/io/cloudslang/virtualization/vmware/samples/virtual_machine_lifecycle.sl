#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
########################################################################################################################
#!!
#! @description: Performs a complete virtual machine lifecycle (Create-Read-Update-Delete scenario) against a VMware data center
#!   using vSphere commands.
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
#! @input resource_pool: the resource pool for the cloned virtual machine. If not provided then the parent resource pool
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
#! @result FAILURE: an error occurred when trying to create a new virtual machine
#!!#
########################################################################################################################

namespace: io.cloudslang.virtualization.vmware.samples

imports:
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  vms: io.cloudslang.virtualization.vmware.virtual_machines
  utils: io.cloudslang.virtualization.vmware.utils
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
          - exception : ${exception if exception != None else ''}
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
            - ignore_case: True
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
          - exception : ${exception if exception != None else ''}
        navigate:
          - SUCCESS: get_created_text_occurrence
          - FAILURE: CREATE_VIRTUAL_MACHINE_FAILURE

    - get_created_text_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: "${'Success: Created'}"
            - ignore_case: True
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
          - exception : ${exception if exception != None else ''}
        navigate:
          - SUCCESS: get_vm_occurrence
          - FAILURE: LIST_VMS_FAILURE

    - get_vm_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: ${virtual_machine_name}
            - ignore_case: True
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
          - exception : ${exception if exception != None else ''}
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
            - json_path: ['numDisks']
        publish:
          - before_update_value: ${value}
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
          - exception : ${exception if exception != None else ''}
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
          - exception : ${exception if exception != None else ''}
        navigate:
          - SUCCESS: get_updated_disk_number
          - FAILURE: GET_UPDATED_VM_DETAILS_FAILURE

    - get_updated_disk_number:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['numDisks']
        publish:
          - after_update_value: ${value}
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
          - exception : ${exception if exception != None else ''}
        navigate:
          - SUCCESS: is_vm_powered_on
          - FAILURE: POWER_ON_VM_FAILURE

    - is_vm_powered_on:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: "${'successfully powered on'}"
            - ignore_case: True
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
          - exception : ${exception if exception != None else ''}
        navigate:
          - SUCCESS: is_vm_powered_off
          - FAILURE: POWER_OFF_VM_FAILURE

    - is_vm_powered_off:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: "${'successfully powered off'}"
            - ignore_case: True
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
          - exception : ${exception if exception != None else ''}
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
          - exception : ${exception if exception != None else ''}
        navigate:
          - SUCCESS: second_get_vm_occurrence
          - FAILURE: SECOND_LIST_VMS_FAILURE

    - second_get_vm_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: ${virtual_machine_name}
            - ignore_case: True
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

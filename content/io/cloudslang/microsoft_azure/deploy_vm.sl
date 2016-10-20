#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: VM provison flow.
#! @input username: Azure username
#! @input password: Azure password
#! @input location: Specifies the supported Azure location where the virtual machine should be created.
#!                  This can be different from the location of the resource group.
#! @input authority: the authority URL
#! @input resource: the resource URL
#! @input vm_name: virtual machine name
#! @input subscription_id: Azure subscription ID
#! @input resource_group_name: Azure resource group name
#! @input vm_size: Virtual machine size given by Azure
#!                 Example: 'Standard_DS1_v2'
#! @input offer: Virtual machine offer
#!               Example: 'WindowsServer'
#! @input sku: Version of the operating system to be installed on the virtual machine
#!             Example: 2008-R2-SP1
#! @input publisher: Name of the publisher for the operating system offer and sku
#!                   Examople: 'MicrosoftWindowsServer'
#! @input public_ip_address_name: Name of the public address to be created
#! @input virtual_network_name: Name of the virtual network to use
#! @input availability_set_name: Specifies information about the availability set that the virtual machine
#!                               should be assigned to. Virtual machines specified in the same availability set
#!                               are allocated to different nodes to maximize availability.
#! @input storage_account: Name of the storage account to use
#! @input subnet_name: Name of the subnet
#! @input os_platform: Name of the operating system that will be installed
#! @input nic_name: Name of the network interface card
#! @input vm_username: Name of the virtual machine username
#! @input vm_password: Password of the virtual machine username
#! @input tag_name: Name of the tag to be added to the virtual machine
#! @input tag_value: Value of the tag to be added to the vrtual machine
#! @input disk_name: Name of the disk to attach to the virtual machine
#! @input disk_size: Size of the disk to attach to the virtual machine
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - username used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input trust_all_roots: optional - specifies whether to enable weak security over SSL - Default: false
#! @input x_509_hostname_verifier: optional - specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the Trusttore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Default: ''
#! @output output: Information about the virtual machine that has been restarted
#! @output ip_address: the IP address of the virtual machine
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: If there is any error while running the flow, it will be populated, empty otherwise
#! @result SUCCESS: The flow completed successfully.
#! @result GET_AUTH_TOKEN_FAILURE: There was a problem while trying to generate Bearer token
#! @result CREATE_PUBLIC_IP_ADDRESS_FAILURE: There was an error while trying to crate public IP address
#! @result GET_VM_INFO_FAILURE: There was an error while trying to retrieve virtual machine info
#! @result GET_PUBLIC_IP_ADDRESS_FAILURE: There was an error while trying to retrieve ip address list
#! @result COMPARE_POWER_STATE_FAILURE: There was an error while trying to compare power states
#! @result GET_IP_ADDRESS_FAILURE: There was an error while trying to retrieve IP address
#! @result ATTACH_DISK_FAILURE: There was an error while trying to attach disk to virtual machine
#! @result FAILURE: Something went wrong
#! @result GET_NIC_LIST_FAILURE: There was an error while trying to retrieve the nic list
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft_azure
imports:
  strings: io.cloudslang.base.strings
  ip: io.cloudslang.microsoft_azure.compute.network.public_ip_addresses
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  auth: io.cloudslang.microsoft_azure.utility
  nic: io.cloudslang.microsoft_azure.compute.network.network_interface_card
  flow: io.cloudslang.base.flow_control
  lists: io.cloudslang.base.lists
  vm: io.cloudslang.microsoft_azure.compute.virtual_machines
flow:
  name: deploy_vm
  inputs:
    - username
    - password:
        sensitive: true
    - location
    - authority
    - resource
    - vm_name
    - subscription_id
    - resource_group_name
    - vm_size
    - offer
    - sku
    - publisher
    - public_ip_address_name
    - virtual_network_name
    - availability_set_name
    - storage_account
    - subnet_name
    - os_platform
    - nic_name
    - vm_username
    - vm_password
    - tag_name
    - tag_value
    - disk_name
    - disk_size
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
  workflow:
    - get_auth_token:
        do:
          auth.get_auth_token:
            - username
            - password
            - authority
            - resource
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - auth_token
          - return_code
          - error_message: '${exception}'
        navigate:
          - SUCCESS: create_public_ip
          - FAILURE: GET_AUTH_TOKEN_FAILURE
    - create_public_ip:
        do:
          ip.create_public_ip_address:
            - vm_name
            - location
            - subscription_id
            - resource_group_name
            - public_ip_address_name
            - auth_token
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - ip_state: '${output}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: create_network_interface
          - FAILURE: CREATE_PUBLIC_IP_ADDRESS_FAILURE
    - create_network_interface:
        do:
          nic.create_nic:
            - vm_name
            - nic_name
            - location
            - subscription_id
            - resource_group_name
            - public_ip_address_name
            - virtual_network_name
            - subnet_name
            - auth_token
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - nic_state: '${output}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: windows_vm
          - FAILURE: delete_public_ip_address
    - windows_vm:
        do:
          strings.string_equals:
            - first_string: '${os_platform}'
            - second_string: Windows
        navigate:
          - SUCCESS: create_windows_vm
          - FAILURE: linux_vm
    - create_windows_vm:
        do:
          vm.create_windows_vm:
            - subscription_id
            - resource_group_name
            - vm_name
            - nic_name
            - location
            - vm_username
            - vm_password
            - vm_size
            - publisher
            - sku
            - offer
            - availability_set_name
            - storage_account
            - auth_token
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - vm_state: '${output}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: get_vm_info
          - FAILURE: delete_nic
    - get_vm_info:
        do:
          vm.get_vm_details:
            - subscription_id
            - resource_group_name
            - vm_name
            - auth_token
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - vm_info: '${output}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: check_vm_state
          - FAILURE: GET_VM_INFO_FAILURE
    - check_vm_state:
        do:
          json.get_value:
            - json_input: '${vm_info}'
            - json_path: 'properties,provisioningState'
        publish:
          - expected_vm_state: '${return_result}'
        navigate:
          - SUCCESS: compare_power_state
          - FAILURE: COMPARE_POWER_STATE_FAILURE
    - compare_power_state:
        do:
          strings.string_equals:
            - first_string: '${expected_vm_state}'
            - second_string: Succeeded
        navigate:
          - FAILURE: sleep
          - SUCCESS: wait_before_check
    - sleep:
        do:
          flow.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: get_vm_info
          - FAILURE: on_failure
    - get_vm_public_ip_address:
        do:
          ip.list_public_ip_addresses_within_resource_group:
            - subscription_id
            - resource_group_name
            - auth_token
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - ip_details: '${output}'
          - status_code
          - error_message
        navigate:
          - FAILURE: GET_PUBLIC_IP_ADDRESS_FAILURE
          - SUCCESS: wait_for_response
    - get_nic_list:
        do:
          json.json_path_query:
            - json_object: '${ip_details}'
            - json_path: 'value.*.name'
        publish:
          - nics: '${return_result}'
        navigate:
          - SUCCESS: get_nic_location
          - FAILURE: GET_NIC_LIST_FAILURE
    - get_nic_location:
        do:
          lists.find_all:
            - list: '${nics}'
            - element: "${'\"' + nic_name + '\"'}"
            - ignore_case: 'true'
        publish:
          - indices
        navigate:
          - SUCCESS: get_ip_address
    - get_ip_address:
        do:
          json.json_path_query:
            - json_object: '${ip_details}'
            - json_path: "${'value[' + indices + '].properties.ipAddress'}"
        publish:
          - ip_address: '${return_result}'
        navigate:
          - SUCCESS: attach_disk
          - FAILURE: GET_IP_ADDRESS_FAILURE
    - attach_disk:
        do:
          vm.attach_disk_to_vm:
            - subscription_id
            - location: '${location}'
            - resource_group_name
            - auth_token
            - vm_name: '${vm_name}'
            - storage_account: '${storage_account}'
            - disk_name: '${dsk_name}'
            - disk_size: '${disk_size}'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - attached: '${output}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: tag_virtual_machine
          - FAILURE: ATTACH_DISK_FAILURE
    - tag_virtual_machine:
        do:
          vm.tag_vm:
            - subscription_id
            - resource_group_name
            - location
            - vm_name
            - auth_token
            - tag_name
            - tag_value
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - tag: '${output}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
    - create_linux_vm:
        do:
          vm.create_linux_vm:
            - subscription_id: '${subscription_id}'
            - publisher: '${publisher}'
            - auth_token: '${auth_token}'
            - sku: '${sku}'
            - offer: '${offer}'
            - resource_group_name: '${resource_group_name}'
            - vm_name: '${vm_name}'
            - nic_name: '${nic_name}'
            - location: '${location}'
            - vm_username: '${vm_username}'
            - vm_password: '${vm_password}'
            - vm_size: '${vm_size}'
            - availability_set_name: '${availability_set_name}'
            - storage_account: '${storage_account}'
        publish:
          - vm_state: '${output}'
          - status_code: '${status_code}'
          - error_message: '${error_message}'
        navigate:
          - FAILURE: delete_nic
          - SUCCESS: get_vm_info
    - linux_vm:
        do:
          strings.string_equals:
            - first_string: '${os_platform}'
            - second_string: Linux
            - ignore_case: 'true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_linux_vm
    - delete_public_ip_address:
        do:
          ip.delete_public_ip_address:
            - auth_token: '${auth_token}'
            - resource_group_name: '${resource_group_name}'
            - subscription_id: '${subscription_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - delete_nic:
        do:
          nic.delete_nic:
            - auth_token: '${auth_token}'
            - resource_group_name: '${resource_group_name}'
            - nic_name: '${nic_name}'
            - subscription_id: '${subscription_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: wait_before_nic
    - wait_before_check:
        do:
          flow.sleep:
            - seconds: '20'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_vm_public_ip_address
    - wait_before_nic:
        do:
          flow.sleep:
            - seconds: '20'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_public_ip_address
    - wait_for_response:
        do:
          flow.sleep:
            - seconds: '20'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_nic_list
  outputs:
    - output
    - ip_address
    - status_code
    - return_code
    - error_message
  results:
    - SUCCESS
    - GET_AUTH_TOKEN_FAILURE
    - CREATE_PUBLIC_IP_ADDRESS_FAILURE
    - GET_VM_INFO_FAILURE
    - GET_PUBLIC_IP_ADDRESS_FAILURE
    - COMPARE_POWER_STATE_FAILURE
    - GET_IP_ADDRESS_FAILURE
    - ATTACH_DISK_FAILURE
    - FAILURE
    - GET_NIC_LIST_FAILURE

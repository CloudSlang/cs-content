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
#!
#! @input subscription_id: Azure subscription ID
#! @input resource_group_name: Azure resource group name
#! @input username: The username to be used to authenticate to the Azure Management Service.
#! @input password: The password to be used to authenticate to the Azure Management Service.
#! @input authority: optional - URL of the login authority that should be used when retrieving the Authentication Token.
#! @input resource: optional - resource URl for which the Authentication Token is intended
#! @input location: Specifies the supported Azure location where the virtual machine should be created.
#!                  This can be different from the location of the resource group.
#! @input vm_name: virtual machine name
#! @input vm_size: Virtual machine size given by Azure
#!                 Example: 'Standard_DS1_v2'
#! @input offer: Virtual machine offer
#!               Example: 'WindowsServer'
#! @input sku: Version of the operating system to be installed on the virtual machine
#!             Example: '2008-R2-SP1'
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
#!
#! @output output: Information about the virtual machine that has been created
#! @output ip_address: the IP address of the virtual machine
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: If there is any error while running the flow, it will be populated, empty otherwise
#!
#! @result SUCCESS: The flow completed successfully.
#! @result FAILURE: Something went wrong
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure

imports:
  strings: io.cloudslang.base.strings
  ip: io.cloudslang.microsoft.azure.compute.network.public_ip_addresses
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  auth: io.cloudslang.microsoft.azure.utility
  nic: io.cloudslang.microsoft.azure.compute.network.network_interface_card
  flow: io.cloudslang.base.utils
  lists: io.cloudslang.base.lists
  vm: io.cloudslang.microsoft.azure.compute.virtual_machines

flow:
  name: deploy_vm
  inputs:
    - subscription_id
    - resource_group_name
    - username
    - password:
        sensitive: true
    - location
    - authority
    - resource
    - vm_name
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
          - error_message: '${exception}'
        navigate:
          - SUCCESS: create_public_ip
          - FAILURE: FAILURE

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
          - FAILURE: FAILURE

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
          - FAILURE: FAILURE

    - check_vm_state:
        do:
          json.get_value:
            - json_input: '${vm_info}'
            - json_path: 'properties,provisioningState'
        publish:
          - expected_vm_state: '${return_result}'
        navigate:
          - SUCCESS: compare_power_state
          - FAILURE: FAILURE

    - compare_power_state:
        do:
          strings.string_equals:
            - first_string: '${expected_vm_state}'
            - second_string: 'Succeeded'
        navigate:
          - SUCCESS: wait_before_check
          - FAILURE: wait_between_checks

    - wait_between_checks:
        do:
          flow.sleep:
            - seconds: '60'
        navigate:
          - SUCCESS: get_vm_info
          - FAILURE: on_failure

    - wait_before_check:
        do:
          flow.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_vm_public_ip_address
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
          - SUCCESS: wait_for_response
          - FAILURE: FAILURE

    - get_nic_list:
        do:
          json.json_path_query:
            - json_object: ${ip_details}
            - json_path: 'value.*.name'
        publish:
          - nics: '${return_result}'
        navigate:
          - SUCCESS: get_nic_location
          - FAILURE: FAILURE

    - get_nic_location:
        do:
          lists.find_all:
            - list: '${nics}'
            - element: "${'\"' + public_ip_address_name + '\"'}"
            - ignore_case: 'true'
        publish:
          - indices
        navigate:
          - SUCCESS: get_ip_address

    - get_ip_address:
        do:
          json.json_path_query:
            - json_object: '${ip_details}'
            - json_path: "${'value' + indices + '.properties.ipAddress'}"
        publish:
          - ip_address: '${return_result}'
        navigate:
          - SUCCESS: attach_disk
          - FAILURE: FAILURE

    - attach_disk:
        do:
          vm.attach_disk_to_vm:
            - subscription_id
            - location: '${location}'
            - resource_group_name
            - auth_token
            - vm_name: '${vm_name}'
            - storage_account: '${storage_account}'
            - disk_name: '${disk_name}'
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
          - status_code
          - error_message
        navigate:
          - SUCCESS: tag_virtual_machine
          - FAILURE: FAILURE

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
          - SUCCESS: get_vm_info
          - FAILURE: delete_nic

    - linux_vm:
        do:
          strings.string_equals:
            - first_string: '${os_platform}'
            - second_string: Linux
            - ignore_case: 'true'
        navigate:
          - SUCCESS: create_linux_vm
          - FAILURE: on_failure

    - delete_public_ip_address:
        do:
          ip.delete_public_ip_address:
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
        navigate:
          - SUCCESS: on_failure
          - FAILURE: on_failure

    - delete_nic:
        do:
          nic.delete_nic:
            - nic_name
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
        navigate:
          - SUCCESS: wait_before_nic
          - FAILURE: on_failure

    - wait_before_nic:
        do:
          flow.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: delete_public_ip_address
          - FAILURE: on_failure

    - wait_for_response:
        do:
          flow.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_nic_list
          - FAILURE: on_failure

  outputs:
    - output
    - ip_address
    - status_code
    - error_message
  results:
    - SUCCESS
    - FAILURE

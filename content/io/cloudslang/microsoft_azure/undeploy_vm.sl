#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: VM deprovison flow.
#! @input subscription_id: Azure subscription ID
#! @input resource_group_name: Azure resource group name
#! @input username: Azure username
#! @input password: Azure password
#! @input authority: the authority URL
#! @input resource: the resource URL
#! @input vm_name: virtual machine name
#! @input public_ip_address_name: Name of the public address to be created
#! @input virtual_network_name: Name of the virtual network to use
#! @input availability_set_name: Specifies information about the availability set that the virtual machine
#!                               should be assigned to. Virtual machines specified in the same availability set
#!                               are allocated to different nodes to maximize availability.
#! @input storage_account: Name of the storage account to use
#! @input nic_name: Name of the network interface card
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
#! @output output: Information about the virtual machine that has been deprovisioned
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: If there is any error while running the flow, it will be populated, empty otherwise
#!
#! @result SUCCESS: The flow completed successfully.
#! @result FAILURE: Something went wrong
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft_azure

imports:
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  flow: io.cloudslang.base.flow_control
  auth: io.cloudslang.microsoft_azure.utility
  vm: io.cloudslang.microsoft_azure.compute.virtual_machines
  ip: io.cloudslang.microsoft_azure.compute.network.public_ip_addresses
  nic: io.cloudslang.microsoft_azure.compute.network.network_interface_card

flow:
  name: undeploy_vm
  inputs:
    - subscription_id
    - resource_group_name
    - username
    - authority
    - resource
    - vm_name
    - public_ip_address_name
    - nic_name
    - password:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        sensitive: true
    - trust_keystore:
        required: false
    - trust_password:
        default: ''
        required: false
        sensitive: true
    - trust_all_roots:
        required: false
        default: 'false'
    - x_509_hostname_verifier:
        required: false
        default: 'strict'


  workflow:

    - get_auth_token:
        do:
          auth.get_auth_token:
            - username: '${username}'
            - password: '${password}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - auth_token
          - return_code
          - error_message: ${exception}
        navigate:
          - SUCCESS: stop_and_deallocate_vm
          - FAILURE: on_failure

    - stop_and_deallocate_vm:
        do:
          vm.stop_and_deallocate_vm:
            - subscription_id: '${subscription_id}'
            - auth_token: '${auth_token}'
            - vm_name: '${vm_name}'
            - resource_group_name: '${resource_grouo_name}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - proxy_host: '${proxy_host}'
            - x_509_hostname_verifier
            - trust_all_roots
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
        publish:
          - status_code
          - error_message
        navigate:
          - SUCCESS: delete_vm
          - FAILURE: on_failure

    - delete_vm:
        do:
          vm.delete_vm:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_grouo_name}'
            - auth_token: '${auth_token}'
            - vm_name: '${vm_name}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_port}'
            - proxy_host: '${proxy_port}'
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
        publish:
          - status_code
          - error_message
        navigate:
          - SUCCESS: list_vms_in_a_resource_group
          - FAILURE: on_failure

    - list_vms_in_a_resource_group:
        do:
          vm.list_vms_in_a_resource_group:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_grouo_name}'
            - auth_token: '${auth_token}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
        publish:
          - deleted_vm: '${output}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: retrieve_vm
          - FAILURE: on_failure

    - retrieve_vm:
        do:
          json.json_path_query:
            - json_object: '${deleted_vm}'
            - json_path: value.vm_name
        publish:
          - return_deleted: '${return_result}'
        navigate:
          - SUCCESS: check_empty_vm
          - FAILURE: on_failure

    - check_empty_vm:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '${return_deleted}'
            - string_to_find: '${vm_name}'
        navigate:
          - SUCCESS: wait_vm_check
          - FAILURE: delete_nic

    - wait_vm_check:
        do:
          flow.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: list_vms_in_a_resource_group
          - FAILURE: on_failure

    - delete_nic:
        do:
          nic.delete_nic:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_grouo_name}'
            - auth_token: '${auth_token}'
            - nic_name: '${nic_name}'
            - proxy_username: '${proxy_username}'
            - proxy_host: '${proxy_host}'
            - proxy_password: '${proxy_password}'
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
        publish:
          - status_code
          - error_message
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_nics_within_resource_group

    - list_nics_within_resource_group:
        do:
          nic.list_nics_within_resource_group:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_grouo_name}'
            - auth_token: '${auth_token}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
        publish:
          - status_code
          - error_message
        publish:
          - nics: '${output}'
        navigate:
          - SUCCESS: retrieve_nics
          - FAILURE: on_failure

    - retrieve_nics:
        do:
          json.json_path_query:
            - json_object: '${nics}'
            - json_path: 'value.*.name'
        publish:
          - nics_result: '${return_result}'
        navigate:
          - SUCCESS: check_empty_nic
          - FAILURE: on_failure

    - check_empty_nic:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '${nics_result}'
            - string_to_find: '${nic_name}'
        navigate:
          - SUCCESS: wait_nic_check
          - FAILURE: delete_public_ip_address

    - wait_nic_check:
        do:
          flow.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: list_nics_within_resource_group
          - FAILURE: on_failure

    - delete_public_ip_address:
        do:
          ip.delete_public_ip_address:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_grouo_name}'
            - auth_token: '${auth_token}'
            - public_ip_address_name: '${public_ip_address_name}'
            - proxy_host: '${proxy_host}'
            - trust_all_roots
            - x_509_hostname_verifier
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
        publish:
          - status_code
          - error_message
        navigate:
          - SUCCESS: list_public_ip_addresses_within_resource_group
          - FAILURE: on_failure

    - list_public_ip_addresses_within_resource_group:
        do:
          ip.list_public_ip_addresses_within_resource_group:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_grouo_name}'
            - auth_token: '${auth_token}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
        publish:
          - status_code
          - error_message
        publish:
          - ips_result: '${output}'
        navigate:
          - SUCCESS: retrieve_ips
          - FAILURE: on_failure

    - retrieve_ips:
        do:
          json.json_path_query:
            - json_object: '${ips_result}'
            - json_path: 'value.*.name'
        publish:
          - ips_response: '${return_result}'
        navigate:
          - SUCCESS: check_empty_ip
          - FAILURE: on_failure

    - check_empty_ip:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '${ips_response}'
            - string_to_find: '${public_ip_address_name}'
        navigate:
          - SUCCESS: wait_ip_check
          - FAILURE: SUCCESS

    - wait_ip_check:
        do:
          flow.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: list_public_ip_addresses_within_resource_group
          - FAILURE: on_failure
  outputs:
    - return_code
    - status_code
    - error_message

  results:
    - SUCCESS
    - FAILURE

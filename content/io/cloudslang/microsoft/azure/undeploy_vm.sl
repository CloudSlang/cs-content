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
#!
#! @input subscription_id: Azure subscription ID
#! @input resource_group_name: Azure resource group name
#! @input username: The username to be used to authenticate to the Azure Management Service.
#! @input password: The password to be used to authenticate to the Azure Management Service.
#! @input login_authority: optional - URL of the login authority that should be used when retrieving the Authentication Token.
#! @input vm_name: virtual machine name
#! @input public_ip_address_name: Name of the public address to be created
#! @input virtual_network_name: Name of the virtual network to use
#! @input availability_set_name: Specifies information about the availability set that the virtual machine
#!                               should be assigned to. Virtual machines specified in the same availability set
#!                               are allocated to different nodes to maximize availability.
#! @input storage_account: Name of the storage account to use
#! @input nic_name: Name of the network interface card
#! @input connect_timeout: optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: optional - time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
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

namespace: io.cloudslang.microsoft.azure

imports:
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  flow: io.cloudslang.base.utils
  auth: io.cloudslang.microsoft.azure.utility
  vm: io.cloudslang.microsoft.azure.compute.virtual_machines
  ip: io.cloudslang.microsoft.azure.compute.network.public_ip_addresses
  nic: io.cloudslang.microsoft.azure.compute.network.network_interface_card

flow:
  name: undeploy_vm

  inputs:
    - subscription_id
    - resource_group_name
    - username
    - login_authority
    - vm_name
    - password:
        sensitive: true
    - connect_timeout:
        default: "0"
        required: false
    - socket_timeout:
        default: "0"
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_all_roots:
        required: false
        default: 'false'
    - x_509_hostname_verifier:
        required: false
        default: 'strict'
    - trust_keystore:
        required: false
    - trust_password:
        default: ''
        required: false
        sensitive: true


  workflow:

    - get_auth_token:
        do:
          auth.get_auth_token:
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - auth_token
          - return_code
          - error_message: ${exception}
        navigate:
          - SUCCESS: stop_vm
          - FAILURE: on_failure

    - stop_vm:
        do:
          vm.stop_vm:
            - subscription_id
            - resource_group_name
            - auth_token
            - vm_name
            - connect_timeout
            - socket_timeout
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - x_509_hostname_verifier
            - trust_all_roots
            - trust_keystore
            - trust_password
        publish:
          - status_code
          - error_message
        navigate:
          - SUCCESS: delete_vm
          - FAILURE: on_failure

    - delete_vm:
        do:
          vm.delete_vm:
            - subscription_id
            - resource_group_name
            - auth_token
            - vm_name
            - connect_timeout
            - socket_timeout
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
          - SUCCESS: list_vms_in_a_resource_group
          - FAILURE: on_failure

    - list_vms_in_a_resource_group:
        do:
          vm.list_vms_in_a_resource_group:
            - subscription_id
            - resource_group_name
            - auth_token
            - connect_timeout
            - socket_timeout
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - deleted_vm: ${output}
          - status_code
          - error_message
        navigate:
          - SUCCESS: retrieve_vm
          - FAILURE: on_failure

    - retrieve_vm:
        do:
          json.json_path_query:
            - json_object: '${deleted_vm}'
            - json_path: 'value.*.vm_name'
        publish:
          - return_deleted: ${return_result}
        navigate:
          - SUCCESS: check_empty_vm
          - FAILURE: on_failure

    - check_empty_vm:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '${return_deleted}'
            - string_to_find: ${vm_name}
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
            - subscription_id
            - resource_group_name
            - auth_token
            - nic_name: ${vm_name + '-nic'}
            - connect_timeout
            - socket_timeout
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
          - FAILURE: on_failure
          - SUCCESS: list_nics_within_resource_group

    - list_nics_within_resource_group:
        do:
          nic.list_nics_within_resource_group:
            - subscription_id
            - resource_group_name
            - auth_token
            - connect_timeout
            - socket_timeout
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
        publish:
          - nics: ${output}
        navigate:
          - SUCCESS: retrieve_nics
          - FAILURE: on_failure

    - retrieve_nics:
        do:
          json.json_path_query:
            - json_object: ${nics}
            - json_path: 'value.*.name'
        publish:
          - nics_result: ${return_result}
        navigate:
          - SUCCESS: check_empty_nic
          - FAILURE: on_failure

    - check_empty_nic:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${nics_result}
            - string_to_find: ${nic_name}
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
            - subscription_id
            - resource_group_name
            - auth_token
            - public_ip_address_name: ${vm_name + '-ip'}
            - connect_timeout
            - socket_timeout
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
          - SUCCESS: list_public_ip_addresses_within_resource_group
          - FAILURE: on_failure

    - list_public_ip_addresses_within_resource_group:
        do:
          ip.list_public_ip_addresses_within_resource_group:
            - subscription_id
            - resource_group_name
            - auth_token
            - connect_timeout
            - socket_timeout
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
        publish:
          - ips_result: ${output}
        navigate:
          - SUCCESS: retrieve_ips
          - FAILURE: on_failure

    - retrieve_ips:
        do:
          json.json_path_query:
            - json_object: ${ips_result}
            - json_path: 'value.*.name'
        publish:
          - ips_response: ${return_result}
        navigate:
          - SUCCESS: check_empty_ip
          - FAILURE: on_failure

    - check_empty_ip:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ips_response}
            - string_to_find: ${public_ip_address_name}
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

#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Restart virtual machine flow.
#!
#! @input subscription_id: Azure subscription ID
#! @input location: Specifies the supported Azure location where the virtual machine should be created.
#!                  This can be different from the location of the resource group.
#! @input username: The username to be used to authenticate to the Azure Management Service.
#! @input password: The password to be used to authenticate to the Azure Management Service.
#! @input authority: the authority URL
#! @input resource: the resource URL
#! @input vm_name: virtual machine name
#! @input resource_group_name: Azure resource group name
#! @input polling_interval: Time to wait between checks
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - username used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the Trusttore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Default: ''
#! @input trust_all_roots: optional - specifies whether to enable weak security over SSL - Default: false
#! @input x_509_hostname_verifier: optional - specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#!
#! @output output: Information about the virtual machine that has been restarted
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: If there is any error while running the flow, it will be populated, empty otherwise
#!
#! @result SUCCESS: The flow completed successfully.
#! @result GET_AUTH_TOKEN_FAILURE: There was an error while trying to get the authentication token
#! @result RESTART_VM_FAILURE: There was an error while trying to restart the virtual machine
#! @result GET_POWER_STATE_FAILURE: There was an error while trying to retrieve the power state of the VM.
#! @result COMPARE_POWER_STATE_FAILURE: There was an error while trying to compare the power state excepted and received.
#! @result FAILURE: There was an error while trying to run every step of the flow.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  flow: io.cloudslang.base.utils
  auth: io.cloudslang.microsoft.azure.utility
  vm: io.cloudslang.microsoft.azure.compute.virtual_machines

flow:
  name: restart_vm

  inputs:
    - username
    - password:
        sensitive: true
    - authority
    - resource
    - vm_name
    - subscription_id
    - resource_group_name
    - polling_interval:
        default: '30'
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_all_roots:
        required: false
        default: 'false'
    - x_509_hostname_verifier:
        required: false
        default: 'strict'
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        default: ''
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
          - error_message: ${exception}
        navigate:
          - SUCCESS: restart_vm
          - FAILURE: GET_AUTH_TOKEN_FAILURE

    - restart_vm:
        do:
          vm.restart_vm:
            - vm_name
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
          - output
          - error_message
        navigate:
          - SUCCESS: get_power_state
          - FAILURE: RESTART_VM_FAILURE

    - get_power_state:
         do:
           vm.get_power_state:
            - vm_name
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
           - power_state: ${output}
           - error_message
         navigate:
           - SUCCESS: check_power_state
           - FAILURE: GET_POWER_STATE_FAILURE

    - check_power_state:
        do:
          json.get_value:
            - json_input: ${power_state}
            - json_path: 'statuses,1,code'
        publish:
          - expected_power_state: ${return_result}
        navigate:
          - SUCCESS: compare_power_state
          - FAILURE: COMPARE_POWER_STATE_FAILURE

    - compare_power_state:
        do:
          strings.string_equals:
            - first_string: ${expected_power_state}
            - second_string: 'PowerState/running'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: sleep

    - sleep:
        do:
          flow.sleep:
            - seconds: ${polling_interval}
        navigate:
          - SUCCESS: get_power_state
          - FAILURE: FAILURE

  outputs:
    - output
    - status_code
    - return_code
    - error_message

  results:
    - SUCCESS
    - GET_AUTH_TOKEN_FAILURE
    - RESTART_VM_FAILURE
    - GET_POWER_STATE_FAILURE
    - COMPARE_POWER_STATE_FAILURE
    - FAILURE


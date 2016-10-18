#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: E2E stop and deallocate virtual machine flow.
#!
#! @input subscription_id: Azure subscription ID
#! @input location: Specifies the supported Azure location where the virtual machine should be created.
#!                  This can be different from the location of the resource group.
#! @input username: Azure username
#! @input password: Azure password
#! @input authority: the authority URL
#! @input resource: the resource URL
#! @input vm_name: virtual machine name
#! @input resource_group_name: Azure resource group name
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                        trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the Trusttore file. If trust_all_roots is false and trust_keystore is empty,
#!                        trustPassword default will be supplied.
#!                        Default value: ''
#! @input keystore: optional - the pathname of the Java KeyStore file. You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is 'true' this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: optional - the password associated with the KeyStore file. If trust_all_roots is false and keystore
#!                           is empty, keystore_password default will be supplied.
#!                           Default value: ''
#! @input trust_all_roots: optional - specifies whether to enable weak security over SSL - Default: false
#! @input x_509_hostname_verifier: optional - specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - username used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#!
#! @output output: Information about the virtual machine that has been stopped and deallocated
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: If there is any error while running the flow, it will be populated, empty otherwise
#!
#! @result SUCCESS: The E2E flow completed successfully.
#! @result GET_AUTH_TOKEN_FAILURE: There was an error while trying to get the authentication token
#! @result STOP_AND_DEALLOCATE_VM_FAILURE: There was an error while trying to stop and deallocate the virtual machine
#! @result GET_POWER_STATE_FAILURE: There was an error while trying to retrieve the power state of the VM.
#! @result COMPARE_POWER_STATE_FAILURE: There was an error while trying to compare the power state excepted and received.
#! @result FAILURE: There was an error while trying to run every step of the flow.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft_azure

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  flow: io.cloudslang.base.flow_control
  auth: io.cloudslang.microsoft_azure.utility
  vm: io.cloudslang.microsoft_azure.compute.virtual_machines

flow:
  name: stop_and_deallocate_vm

  inputs:
    - username
    - password
    - authority
    - resource
    - vm_name
    - subscription_id
    - resource_group_name
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
    - keystore:
        required: false
    - keystore_password:
        required: false
        default: ''
        sensitive: true
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
          - SUCCESS: stop_and_deallocate_vm
          - FAILURE: GET_AUTH_TOKEN_FAILURE

    - stop_and_deallocate_vm:
        do:
          vm.stop_vm:
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
            - keystore
            - keystore_password
            - trust_keystore
            - trust_password
        publish:
          - output
          - error_message
        navigate:
          - SUCCESS: get_power_state
          - FAILURE: STOP_AND_DEALLOCATE_VM_FAILURE

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
            - keystore
            - keystore_password
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
            - second_string: 'PowerState/stopped'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: sleep

    - sleep:
        do:
          flow.sleep:
            - seconds: '30'
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
      - STOP_AND_DEALLOCATE_VM_FAILURE
      - GET_POWER_STATE_FAILURE
      - COMPARE_POWER_STATE_FAILURE
      - FAILURE


#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs an HTTP request to add a virtual disk to a virtual machine
#!
#! @input subscription_id: Azure subscription ID
#! @input api_version: The API version used to create calls to Azure
#! @input auth_token: Azure authorization Bearer token
#!                     Default: '2015-06-15'
#! @input resource_group_name: Azure resource group name
#! @input preemptive_auth: optional - if 'true' authentication info will be sent in the first request, otherwise a request
#!                         with no authentication info will be made and if server responds with 401 and a header
#!                         like WWW-Authenticate: Basic realm="myRealm" only then will the authentication info
#!                         will be sent - Default: true
#! @input vm_name: virtual machine name
#! @input disk_name: Name of the virtual disk to be attached
#! @input disk_size: Size of the virtual disk to be attached
#! @input resource_group_name: Azure resource group name
#! @input storage_account: Storage account name
#! @input vm_name: Specifies the name of the virtual machine. This name should be unique within the resource group.\
#! @input location: Specifies the supported Azure location where the virtual machine should be created.
#!                  This can be different from the location of the resource group.
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                        trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the Trusttore file. If trust_all_roots is false and trust_keystore is empty,
#!                        trustPassword default will be supplied.
#!                        Default value: ''
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
#! @output output: json response with information about the added virtual disk to the virtual machine
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: Error message in case something went wrong
#!
#! @result SUCCESS: virtual machine updated with the added virtual disk successfully.
#! @result FAILURE: There was an error while trying to add a virtual disk to the virtual machine.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft_azure.compute.virtual_machines

imports:
  strings: io.cloudslang.base.strings
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: attach_disk_to_vm

  inputs:
    - auth_token
    - location
    - subscription_id
    - resource_group_name
    - vm_name
    - storage_account
    - disk_name
    - disk_size
    - api_version:
        required: false
        default: '2015-06-15'
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxy_port:
        default: "8080"
        required: false
    - proxy_host:
        required: false
    - trust_all_roots:
        default: "false"
        required: false
    - x_509_hostname_verifier:
        default: "strict"
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        default: ''
        required: false
        sensitive: true

  workflow:
    - attach_disk_to_vm:
        do:
          http.http_client_put:
            - url: >
                ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +
                resource_group_name + '/providers/Microsoft.Compute/virtualMachines/' + vm_name +
                '?validating=false&api-version=' + api_version}
            - body: >
                ${'{"name":"' + vm_name + '","location":"' + location +
                '","properties":{"storageProfile":{"dataDisks":[{"name":"' + disk_name + '","diskSizeGB":"' +
                disk_size + '","lun":0,"vhd":{"uri":"http://' + storage_account + '.blob.core.windows.net/vhds/' +
                disk_name + '.vhd"},"createOption":"empty"}]}}}'}
            - headers: "${'Authorization: ' + auth_token}"
            - auth_type: 'anonymous'
            - preemptive_auth: 'true'
            - content_type: 'application/json'
            - request_character_set: 'UTF-8'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - output: ${return_result}
          - status_code
        navigate:
          - SUCCESS: check_error_status
          - FAILURE: check_error_status

    - check_error_status:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '400,401,404'
            - string_to_find: ${status_code}
        navigate:
          - SUCCESS: retrieve_error
          - FAILURE: retrieve_success

    - retrieve_error:
        do:
          json.get_value:
            - json_input: ${output}
            - json_path: 'error,message'
        publish:
          - error_message: ${return_result}
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: retrieve_success

    - retrieve_success:
        do:
          strings.string_equals:
            - first_string: ${status_code}
            - second_string: '200'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE



  outputs:
    - output
    - status_code
    - error_message

  results:
    - SUCCESS
    - FAILURE

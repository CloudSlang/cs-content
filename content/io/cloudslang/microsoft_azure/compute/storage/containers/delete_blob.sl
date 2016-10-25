#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs an HTTP request to delete a blob inside a container
#!
#! @input subscription_id: Azure subscription ID
#! @input resource_group_name: Azure resource group name
#! @input list_cont_auth_header: Azure Storage authorization key
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-04-05'
#! @input nic_name: network interface card name
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
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the Trusttore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!
#! @output output: json response with information of the deleted network interface card
#! @output status_code: 202 if request completed successfully, 204 if resource does not exist,
#!                      others in case something went wrong
#! @output error_message: If a network interface card is not found the error message will be populated with a response,
#!                        empty otherwise
#!
#! @result SUCCESS: Blob deleted successfully.
#! @result FAILURE: There was an error while trying to delete the blob.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft_azure.compute.storage.containers

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  storage_auth: io.cloudslang.microsoft_azure.compute.storage

flow:
  name: delete_blob

  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - list_cont_auth_header
    - api_version:
        required: false
        default: '2015-04-05'
    - storage_account
    - container
    - blob_name
    - proxy_host:
        required: false
    - proxy_port:
        default: "8080"
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_all_roots:
        default: "false"
        required: false
    - x_509_hostname_verifier:
        default: "strict"
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true

  workflow:
    - get_storage_account:
        do:
          storage_auth.get_storage_account_keys:
            - subscription_id
            - resource_group_name
            - auth_token
            - storage_account
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - key
          - date
          - error_message
        navigate:
          - SUCCESS: delete_blob
          - FAILURE: FAILURE

    - delete_blob:
        do:
          http.http_client_delete:
            - url: ${'https://' + storage_account + '.blob.core.windows.net/' + container + '/' + blob_name}
            - headers: >
                ${'Authorization: SharedKey ' + storage_account + ':' + list_cont_auth_header + '\n' +
                'x-ms-date:' + date + '\n' +
                'x-ms-version:' + api_version}
            - auth_type: 'anonymous'
            - preemptive_auth: 'true'
            - content_type: 'application/json'
            - request_character_set: 'UTF-8'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - output: ${return_result}
          - status_code
          - return_code
        navigate:
          - SUCCESS: check_error_status
          - FAILURE: check_error_status

    - check_error_status:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '204,400,401,404,411,412'
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
          strings.string_occurrence_counter:
            - string_in_which_to_search: '200,201,202'
            - string_to_find: ${status_code}
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


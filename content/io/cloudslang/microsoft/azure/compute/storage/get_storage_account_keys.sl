#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs an HTTP request to return the access keys for the specified storage account
#!
#! @input subscription_id: Azure subscription ID
#! @input resource_group_name: resource group name
#! @input auth_token: authentication token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-06-15'
#! @input storage_account: storage account name from which the key will be retrieved
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
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the Trusttore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!
#! @output output: json response with the access keys for the specified storage account
#! @output key: the storage account key
#! @output status_code: 202 if request completed successfully, others in case something went wrong
#! @output error_message: an error message in case there was an error while trying to retrieve the storage account key
#!
#! @result SUCCESS: returned the access keys for the specified storage account successfully
#! @result FAILURE: there was an error while trying to return the access keys for the specified storage account.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.storage

imports:
  http: io.cloudslang.base.http
  strings: io.cloudslang.base.strings
  json: io.cloudslang.base.json
  datetime: io.cloudslang.base.datetime

flow:
  name: get_storage_account_keys

  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - api_version:
        required: false
        default: '2015-06-15'
    - storage_account
    - connect_timeout:
        default: "0"
        required: false
    - socket_timeout:
        default: "0"
        required: false
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

    - get_storage_account_keys:
        do:
          http.http_client_post:
            - url: >
                ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +
                resource_group_name + '/providers/Microsoft.Storage/storageAccounts/' + storage_account +
                '/listKeys?api-version=' + api_version}
            - headers: >
                     ${'Content-Length: 0' + '\n' +
                     'Authorization: '+ auth_token}
            - auth_type: 'anonymous'
            - preemptive_auth: 'true'
            - content_type: 'application/json'
            - request_character_set: 'UTF-8'
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
          - output: ${return_result}
        navigate:
          - SUCCESS: check_error_status
          - FAILURE: check_error_status

    - check_error_status:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '400,401,404,409'
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
            - string_in_which_to_search: '200,202'
            - string_to_find: ${status_code}
        navigate:
          - SUCCESS: get_storage_account_key
          - FAILURE: FAILURE

    - get_storage_account_key:
        do:
          json.get_value:
            - json_input: ${output}
            - json_path: 'key1'
        publish:
          - key: ${return_result}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - output
    - key
    - status_code
    - error_message

  results:
    - SUCCESS
    - FAILURE

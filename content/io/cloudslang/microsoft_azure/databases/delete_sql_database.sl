#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs an HTTP request to delete an sql database
#!
#! @input subscription_id: Azure subscription ID
#! @input api_version: The API version used to create calls to Azure
#! @input auth_type: optional - authentication type
#!                   Default: "anonymous"
#! @input server_name: Sql server name
#! @input database_name: sql database name
#! @input content_type: optional - content type that should be set in the request header, representing the MIME-type
#!                      of the data in the message body
#!                      Default: "application/json; charset=utf-8"
#! @input location: Specifies the supported Azure location where the sql database should be created.
#!                  This can be different from the location of the resource group.
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                        trustAllRoots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the TrustStore file. If trustAllRoots is false and trustKeystore is empty,
#!                        trustPassword default will be supplied.
#!                        Default value: ''
#! @input keystore: optional - the pathname of the Java KeyStore file. You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is 'true' this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: optional - the password associated with the KeyStore file. If trustAllRoots is false and keystore
#!                           is empty, keystorePassword default will be supplied.
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
#! @input connections_max_per_route: optional - maximum limit of connections on a per route basis - Default: '50'
#! @input connections_max_total: optional - maximum limit of connections in total - Default: '500'
#! @input preemptive_auth: optional - if 'true' authentication info will be sent in the first request, otherwise a request
#!                         with no authentication info will be made and if server responds with 401 and a header
#!                         like WWW-Authenticate: Basic realm="myRealm" only then will the authentication info
#!                         will be sent - Default: true
#! @input use_cookies: optional - specifies whether to enable cookie tracking or not - Default: true
#! @input keep_alive: optional - specifies whether to create a shared connection that will be used in subsequent calls
#!                    Default: true
#! @input request_character_set: optional - character encoding to be used for the HTTP request - Default: 'UTF-8'
#! @input chunked_request_entity: optional - data is sent in a series of 'chunks' - Valid: true/false
#!                                Default: "false"
#! @input auth_token: authentication token
#! @input resource_group_name: resource group name
#! @input vm_name: sql database name
#!
#! @output status_code: 202 if request completed successfully, others in case something went wrong
#! @output output: result of the operation
#! @output error_message: An error message in case something went wrong
#!
#! @result SUCCESS: sql database deleted successfully.
#! @result FAILURE: there was an error while trying to delete the sql database.
#!!#
####################################################

namespace: io.cloudslang.microsoft_azure.databases

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: delete_sql_database

  inputs:
    - auth_token
    - server_name
    - database_name
    - resource_group_name
    - subscription_id
    - location
    - api_version:
        required: false
        default: '2014-04-01-preview'
    - auth_type:
        default: 'anonymous'
        required: false
    - preemptive_auth:
        default: 'true'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: 'strict'
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        default: ''
        sensitive: true
        required: false
    - keystore:
        required: false
    - keystore_password:
        default: ''
        sensitive: true
        required: false
    - use_cookies:
        default: 'true'
        required: false
    - keep_alive:
        default: 'true'
        required: false
    - connections_max_per_route:
        default: '20'
        required: false
    - connections_max_total:
        default: '200'
        required: false
    - content_type:
        default: 'application/json'
        required: false
    - request_character_set:
        default: 'UTF-8'
        required: false

  workflow:
    - delete_sql_database:
        do:
          http.http_client_delete:
            - url: ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Sql/servers/' + server_name + '/databases/' + database_name + '?api-version=' + api_version}
            - auth_type
            - headers: "${'Authorization: ' + auth_token}"
            - preemptive_auth
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - use_cookies
            - keep_alive
            - connections_max_per_route
            - connections_max_total
            - content_type
            - request_character_set
        publish:
          - output: ${return_result}
          - status_code
        navigate:
          - FAILURE: check_error_status
          - SUCCESS: check_error_status

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
          strings.string_occurrence_counter:
            - string_in_which_to_search: '200,202'
            - string_to_find: ${status_code}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE


  outputs:
    - status_code
    - output
    - error_message

  results:
    - SUCCESS
    - FAILURE

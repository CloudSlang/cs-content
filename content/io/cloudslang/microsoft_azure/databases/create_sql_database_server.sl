#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs an HTTP request to create an sql database server
#!
#! @input subscription_id: Azure subscription ID
#! @input api_version: The API version used to create calls to Azure
#! @input resource_group_name: resource group name
#! @input location: Specifies the supported Azure location where the virtual machine should be created.
#!                  This can be different from the location of the resource group.
#! @input sql_server_name: Sql database server name
#! @input sql_server_version: Specifies the version of the Azure server
#!                            Default '12.0'
#!                            Accepted values:
#!                            2.0 : Indicates a v11 server. If you change the server version from 12.0 to 2.0 on an
#!                                  existing server, then the request will fail to complete.
#!                            12.0 : Indicates a v12 server. If you change the server version from 2.0 to 12.0 on an
#!                                   existing server, then the server will be migrated from v11 to v12.
#! @input sql_server_state: Specifies the state of the Azure server
#! @input sql_admin_name: Sql database server admin username
#! @input sql_admin_password: Sql database server admin password
#! @input auth_token: Azure authorization Bearer token
#! @input auth_type: optional - authentication type
#!                   Default: "anonymous"
#! @input content_type: optional - content type that should be set in the request header, representing the MIME-type
#!                      of the data in the message body
#!                      Default: "application/json; charset=utf-8"
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
#! @input connect_timeout: optional - time in seconds to wait for a connection to be established - Default: '0' (infinite)
#! @input socket_timeout: optional - time in seconds to wait for data to be retrieved - Default: '0' (infinite)
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - username used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input connections_max_per_root: optional - maximum limit of connections on a per route basis - Default: '50'
#! @input connections_max_total: optional - maximum limit of connections in total - Default: '500'
#! @input use_cookies: optional - specifies whether to enable cookie tracking or not - Default: true
#! @input keep_alive: optional - specifies whether to create a shared connection that will be used in subsequent calls
#!                    Default: true
#! @input request_character_set: optional - character encoding to be used for the HTTP request - Default: 'UTF-8'
#! @input chunked_request_entity: optional - data is sent in a series of 'chunks' - Valid: true/false
#!                                Default: "false"
#!
#! @output output: response with information about the created sql database
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If a database is not found the error message will be populated with a response,
#!                        empty otherwise
#!
#! @result SUCCESS: Database created successfully.
#! @result FAILURE: There was an error while trying to create the database.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft_azure.databases

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: create_sql_database_server

  inputs:
    - auth_token
    - location
    - subscription_id
    - sql_server_name
    - sql_server_state
    - sql_server_version:
        default: '12.0'
    - sql_admin_name
    - sql_admin_password
    - api_version:
        required: false
        default: '2014-04-01-preview'
    - content_type:
        default: 'application/json'
        required: false
    - auth_type:
        default: "anonymous"
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxy_port:
        required: false
        default: "8080"
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
        default: ''
    - trust_password:
        default: ''
        sensitive: true
        required: false
    - keystore:
        required: false
        default: ''
    - keystore_password:
        default: ''
        sensitive: true
        required: false
    - use_cookies:
        default: "true"
        required: false
    - keep_alive:
        default: "true"
        required: false
    - connections_max_per_root:
        default: "50"
        required: false
    - connections_max_total:
        default: "500"
        required: false
    - request_character_set:
        default: 'UTF-8'

  workflow:
    - create_sql_database_server:
        do:
          http.http_client_put:
            - url: ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Sql/servers/' + sql_server_name + '?api-version=' + api_version}
            - body: >
                 ${'{"location":"' + location + '","tags":{"key":"value"},"properties":{"version":"' + sql_server_version + '","administratorLogin":"' +  sql_admin_name + '","administratorLoginPassword":"' + sql_admin_password + '"}}'}
            - headers: "${'Authorization: ' + auth_token}"
            - auth_type
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
            - response_character_set
            - multipart_bodies_content_type
            - chunked_request_entity
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


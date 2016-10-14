#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs an HTTP request to stop a virtual machine
#!
#! @input subscription_id: Azure subscription ID
#! @input url: url to the Azure resource
#! @input auth_type: optional - authentication type
#!                   Default: "anonymous"
#! @input username: username used to connect to Azure
#! @input password: passowrd used to connect to Azure
#! @input content_type: optional - content type that should be set in the request header, representing the MIME-type
#!                      of the data in the message body
#!                      Default: "application/json; charset=utf-8"
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
#! @input trust_all_roots: optional - specifies whether to enable weak security over SSL - Default: true
#! @input x_509_hostname_verifier: optional - specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - username used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input connections_max_per_root: optional - maximum limit of connections on a per route basis - Default: '50'
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
#! @input vm_name: virtual machine name
#!
#! @output output: Result of the operation
#! @output status_code: 202 if request completed successfully, others in case something went wrong
#!
#! @result SUCCESS: virtual machine started successfully.
#! @result FAILURE: There was an error while trying to start the virtual machine.
#!!#
####################################################

namespace: io.cloudslang.microsoft_azure.compute.virtual_machines

imports:
  http: io.cloudslang.base.http
  strings: io.cloudslang.base.strings

flow:
  name: stop_vm

  inputs:
    - url:
        default: ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Compute/virtualMachines/' + vm_name + '/powerOff?api-version=2015-05-01-preview'}
    - subscription_id
    - auth_token
    - resource_group_name
    - vm_name
    - content_type:
        default: 'application/json'
        required: false
    - auth_type:
        default: "anonymous"
        required: false
    - username:
        required: false
    - password:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
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
        required: false
        default: ""
    - keystore:
        required: false
        default: ''
    - keystore_password:
        default: ""
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

  workflow:
    - http_client_post_raw:
        do:
          http.http_client_post:
            - url
            - headers: >
                     ${'Content-Length: 0' + '\n' +
                     'Authorization: Bearer '+ auth_token}
            - auth_type
            - content_type
            - username
            - password
            - preemptive_auth
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x509_hostname_verifier
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - connect_timeout
            - socket_timeout
            - use_cookies
            - keep_alive
            - connections_max_per_route
            - connections_max_total
            - method
        publish:
          - status_code
          - output: ${return_result}
        navigate:
          - SUCCESS: string_equals
          - FAILURE: FAILURE

    - string_equals:
        do:
          strings.string_equals:
            - first_string: '${ status_code }'
            - second_string: '202'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - status_code
    - output

  results:
    - FAILURE
    - SUCCESS

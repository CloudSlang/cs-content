#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs a REST API call to start an embedded cartridge that is not running.
#! @input host: RedHat OpenShift Online host
#! @input username: RedHat OpenShift Online username
#!                  optional
#!                  example: 'someone@mailprovider.com'
#! @input password: RedHat OpenShift Online password used for authentication
#!                  optional
#! @input proxy_host: proxy server used to access RedHat OpenShift Online web site
#!                    optional
#! @input proxy_port: proxy server port
#!                    optional
#!                    default: '8080'
#! @input proxy_username: user name used when connecting to proxy
#!                        optional
#! @input proxy_password: proxy server password associated with <proxy_username> input value
#!                        optional
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                        trustAllRoots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the TrustStore file. If trustAllRoots is false and trustKeystore is empty,
#!                        trustPassword default will be supplied.
#!                        Default value: changeit
#! @input keystore: optional - the pathname of the Java KeyStore file. You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is 'true' this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: optional - the password associated with the KeyStore file. If trustAllRoots is false and keystore
#!                           is empty, keystorePassword default will be supplied.
#!                           Default value: changeit
#! @input domain: name of RedHat OpenShift Online domain in which the application that contains specified cartridge resides
#! @input application_name: RedHat OpenShift Online application name
#! @input cartridge: name of framework to be started
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#!!#
####################################################

namespace: io.cloudslang.cloud.openshift.cartridges

imports:
  rest: io.cloudslang.base.http
  list: io.cloudslang.base.lists

flow:
  name: start_cartridge
  inputs:
    - host
    - username:
        required: false
    - password:
        required: false
        sensitive: true
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
    - trust_keystore: ${get_sp('io.cloudslang.base.http.trust_keystore')}
    - trust_password: ${get_sp('io.cloudslang.base.http.trust_password')}
    - keystore: ${get_sp('io.cloudslang.base.http.keystore')}
    - keystore_password: ${get_sp('io.cloudslang.base.http.keystore_password')}
    - domain
    - application_name
    - cartridge

  workflow:
    - start_cartridge:
        do:
          rest.http_client_post:
            - url: ${'https://' + host + '/broker/rest/domains/' + domain + '/applications/' + application_name + '/cartridges/' + cartridge + '/events'}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - content_type: 'application/json'
            - body: '{"event":"start"}'
            - headers: 'Accept: application/json'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

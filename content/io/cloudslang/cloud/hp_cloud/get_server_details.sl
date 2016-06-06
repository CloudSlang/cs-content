#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Call to HP Cloud API to fetch details of a server instance.
#! @input server_id: ID of server
#! @input tenant: tenant ID obtained by get_authenication_flow
#! @input token: auth token obtained by get_authenication_flow
#! @input region: HP Cloud region; 'a' or 'b'  (US West or US East)
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
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
#! @output return_result: JSON response
#! @output error_message: message returned when HTTP call fails
#! @output status_code: normal status code is 200
#! @result SUCCESS: operation succeeded, server deleted
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.hp_cloud

imports:
  rest: io.cloudslang.base.http

flow:
  name: get_server_details
  inputs:
    - server_id
    - tenant
    - token:
        sensitive: true
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - trust_keystore: ${get_sp('io.cloudslang.base.http.trust_keystore')}
    - trust_password: ${get_sp('io.cloudslang.base.http.trust_password')}
    - keystore: ${get_sp('io.cloudslang.base.http.keystore')}
    - keystore_password: ${get_sp('io.cloudslang.base.http.keystore_password')}

  workflow:
    - rest_get_server_details:
        do:
          rest.http_client_get:
            - url: ${'https://region-'+region+'.geo-1.compute.hpcloudsvc.com/v2/' + tenant + '/servers/' + server_id}
            - headers: ${'X-AUTH-TOKEN:' + token}
            - content_type: 'application/json'
            - proxy_host
            - proxy_port
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
        publish:
          - return_result
          - error_message
          - status_code

  outputs:
    - return_result
    - error_message
    - status_code

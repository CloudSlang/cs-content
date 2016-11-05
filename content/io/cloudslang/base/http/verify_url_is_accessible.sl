#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks if a url is accessible.
#!
#! @input url: the url
#! @input attempts: attempts to reach host
#! @input time_to_sleep: time in seconds to wait between attempts
#! @input content_type: optional - content type that should be set in the request header, representing the MIME-type
#!                      of the data in the message body - Default: 'application/json'
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
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#!
#! @output output_message: timeout exceeded and url was not accessible
#! @output return_code: '0' if success, '-1' otherwise
#!
#! @result SUCCESS: url is accessible
#! @result FAILURE: url is not accessible
#!!#
####################################################

namespace: io.cloudslang.base.http

imports:
  math: io.cloudslang.base.math
  rest: io.cloudslang.base.http
  utils: io.cloudslang.base.utils
flow:
  name: verify_url_is_accessible
  inputs:
    - url
    - attempts: "1"
    - time_to_sleep:
        default: "1"
        required: false
    - content_type:
        default: "application/json"
    - trust_keystore:
        default: ${get_sp('io.cloudslang.base.network.trust_keystore')}
        required: false
    - trust_password:
        default: ${get_sp('io.cloudslang.base.network.trust_password')}
        required: false
        sensitive: true
    - keystore:
        default: ${get_sp('io.cloudslang.base.network.keystore')}
        required: false
    - keystore_password:
        default: ${get_sp('io.cloudslang.base.network.keystore_password')}
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - http_get:
        do:
          rest.http_client_get:
            - url
            - content_type
            - connect_timeout: "20"
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - proxy_host
            - proxy_port
        publish:
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: check_if_timed_out

    - check_if_timed_out:
         do:
            math.compare_numbers:
              - value1: ${attempts}
              - value2: "0"
         navigate:
           - GREATER_THAN: wait
           - EQUALS: FAILURE
           - LESS_THAN: FAILURE

    - wait:
        do:
          utils.sleep:
              - seconds: ${time_to_sleep}
              - attempts
        publish:
          - attempts: ${str(int(attempts) - 1)}
        navigate:
          - SUCCESS: http_get
          - FAILURE: FAILURE
  outputs:
    - return_code
    - output_message: ${"Url is accessible" if return_code == '0' else "Url is not accessible"}

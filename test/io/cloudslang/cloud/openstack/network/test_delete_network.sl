#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.cloud.openstack.network

imports:
  strings: io.cloudslang.base.strings
  base_print: io.cloudslang.base.print

flow:
  name: test_delete_network

  inputs:
    - token
    - network_id
    - host
    - port
    - protocol
    - username
    - password
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
    - request_body

  workflow:
    - execute_delete_network:
        do:
          delete_network:
            - token
            - network_id
            - host
            - port
            - protocol
            - username
            - password
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
            - request_body        
        publish:
            - returnStr: ${result}
        navigate:
            - SUCCESS: verify_output_is_empty
            - FAILURE: FAILURE

    - verify_output_is_empty:
        do:
          strings.string_equals:
            - first_string: ''
            - second_string: ${returnStr}
        navigate:
            - SUCCESS: SUCCESS
            - FAILURE: OUTPUT_IS_NOT_EMPTY
  results:
    - SUCCESS
    - FAILURE
    - OUTPUT_IS_NOT_EMPTY

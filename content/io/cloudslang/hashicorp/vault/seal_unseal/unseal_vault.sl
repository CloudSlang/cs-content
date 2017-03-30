#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Executes a '/v1/sys/unseal' PUT call against a Vault Server.
#!
#! @input hostname: Vault's FQDN.
#! @input port: Vault's Port.
#! @input protocol: Vault's Protocol.
#!                  Default: 'https'
#!                  Possible values: 'https' and 'http'.
#! @input x_vault_token: Vault's X-VAULT-Token.
#! @input key: A single master share key needed to unseal Vault.
#!             Optional
#! @input reset: True or False reset value. If true, the previously-provided unseal keys are discarded from memory and the unseal process is reset.
#!               Optional
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: User name used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Format: Java KeyStore (JKS)
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Optional
#! @input connect_timeout: Time in seconds to wait for a connection to be established.
#!                         Default: '0' (infinite)
#!                         Optional
#! @input socket_timeout: Time in seconds to wait for data to be retrieved.
#!                        Default: '0' (infinite)
#!                        Optional
#!
#! @output sealed: Boolean. The sealed status of the Vault server.
#! @output progress: The progress number of the Vault server.
#!                   Example: a value of '1' means that unseal process started and one unseal key was provided.
#! @output return_result: The response of the operation in case of success or the error message otherwise.
#! @output error_message: return_result if status_code is not contained in interval between '200' and '299'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!
#! @result SUCCESS: Vault server was accessible and command was triggered property.
#!                  If sealed is false, the Vault server was unsealed.
#!                  If process is '0' the unseal process did not actually start.
#! @result FAILURE: Something went wrong. Most likely the return_result was not as expected.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.vault.seal_unseal

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  vault: io.cloudslang.hashicorp.vault

flow:
  name: unseal_vault

  inputs:
    - hostname
    - port
    - protocol:
        default: 'https'
    - x_vault_token:
        sensitive: true
    - key:
        required: false
        sensitive: true
    - reset:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
    - keystore:
        required: false
    - keystore_password:
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false

  workflow:
    - compute_unseal_body:
        do:
          vault.utils.compute_unseal_body:
            - unseal_key: '${key}'
            - unseal_reset: '${reset}'
        publish:
          - json_body: '${return_result}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: interogate_vault_to_unseal
          - FAILURE: on_failure

    - interogate_vault_to_unseal:
        do:
          http.http_client_put:
            - url: "${protocol + '://' + hostname + ':' + port + '/v1/sys/unseal'}"
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - connect_timeout
            - socket_timeout
            - headers: "${'X-VAULT-Token: ' + x_vault_token}"
            - body: '${json_body}'
            - content_type: application/json
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
        navigate:
          - SUCCESS: get_sealed_status
          - FAILURE: on_failure

    - get_sealed_status:
        do:
          json.json_path_query:
            - json_object: '${return_result}'
            - json_path: .sealed
        publish:
          - sealed: "${''.join( c for c in return_result if  c not in '\"[]' )}"
        navigate:
          - SUCCESS: get_progress
          - FAILURE: on_failure

    - get_progress:
        do:
          json.json_path_query:
            - json_object: '${return_result}'
            - json_path: .progress
        publish:
          - progress: "${''.join( c for c in return_result if  c not in '\"[]' )}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  outputs:
    - sealed
    - progress
    - return_result
    - return_code
    - status_code
    - error_message
    - response_headers

  results:
    - SUCCESS
    - FAILURE
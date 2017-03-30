#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Executes several '/v1/sys/unseal' PUT calls against a Vault Server.
#!               The calls are done in a sync based loop; the number of comma separated keys provided as input control the loop.
#!
#! @input hostname: Vault's FQDN.
#! @input port: Vault's Port.
#! @input protocol: Vault's Protocol.
#!                  Default: 'https'
#!                  Possible values: 'https' and 'http'.
#! @input x_vault_token: Vault's X-VAULT-Token.
#! @input keys: A list of master share keys needed to unseal Vault.
#!              Example: by default most Vault servers need three keys to be provided in order for the Vault to be unsealed.
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
#! @result SUCCESS: Unseal process started properly. If sealed is false, the Vault server was unsealed.
#! @result FAILURE: Something went wrong. Most likely the return_result was not as expected.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.vault.seal_unseal

imports:
  vault: io.cloudslang.hashicorp.vault

flow:
  name: unseal_vault_now

  inputs:
    - hostname
    - port
    - protocol:
        default: 'https'
    - x_vault_token:
        sensitive: true
    - keys:
        required: true
        sensitive: true
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
    - unseal:
        loop:
          for: i in keys
          do:
            vault.seal_unseal.unseal_vault:
              - hostname
              - port
              - protocol
              - x_vault_token
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
              - key: '${i}'
          break:
            - FAILURE
          publish:
            - sealed
            - progress
            - return_result
            - return_code
            - error_message
            - status_code
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
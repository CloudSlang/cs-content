#!!
#! @input hostname: Vault FQDN
#! @input port: Vault Port
#! @input protocol: Vault Protocol
#! @input x_vault_token: Vault Token
#!!#
namespace: io.cloudslang.hashicorp.vault.seal_unseal
flow:
  name: seal
  inputs:
    - hostname
    - port
    - protocol
    - x_vault_token:
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
  workflow:
    - interogate_vault_to_seal:
        do:
          io.cloudslang.base.http.http_client_put:
            - url: "${protocol + '://' + hostname + ':' + port + '/v1/sys/seal'}"
            - headers: "${'X-VAULT-Token: ' + x_vault_token}"
            - content_type: application/json
        publish:
          - return_result: '${return_result}'
          - error_message: '${error_message}'
          - return_code: '${return_code}'
          - status_code: '${status_code}'
          - response_headers: '${response_headers}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_status_code_204
    - is_status_code_204:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '204'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - status_code: '${status_code}'
    - error_message: '${error_message}'
    - response_headers: '${response_headers}'
  results:
    - FAILURE
    - SUCCESS
#!!
#! @input hostname: Vault FQDN
#! @input port: Vault Port
#! @input protocol: Vault Protocol
#! @input x_vault_token: Vault Token
#! @input keys: keys, required, a list of keys to unseal vault
#!!#
namespace: io.cloudslang.hashicorp.vault.seal_unseal
flow:
  name: unseal_vault_now
  inputs:
    - hostname
    - port
    - protocol
    - x_vault_token:
        sensitive: true
    - keys:
        required: true
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
    - unseal:
        loop:
          for: i in keys
          do:
            io.cloudslang.demos.vault.unseal:
              - hostname: '${hostname}'
              - port: '${port}'
              - protocol: '${protocol}'
              - x_vault_token: '${x_vault_token}'
              - key: '${i}'
          break:
            - FAILURE
          publish:
            - sealed: '${sealed}'
            - progress: '${progress}'
            - return_result: '${return_result}'
            - return_code: '${return_code}'
            - error_message: '${error_message}'
            - status_code: '${status_code}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - sealed: '${sealed}'
    - progress: '${progress}'
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - status_code: '${status_code}'
    - error_message: '${error_message}'
    - response_headers: '${response_headers}'
  results:
    - FAILURE
    - SUCCESS
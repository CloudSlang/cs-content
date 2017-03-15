#!!
#! @input hostname: Vault FQDN
#! @input port: Vault Port
#! @input protocol: Vault Protocol
#! @input x_vault_token: Vault Token
#!!#
namespace: io.cloudslang.hashicorp.vault.secrets
flow:
  name: list_secrets
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
    - trust_all_root:
        required: false
    - x_509_hostname_verifier:
        required: false
  workflow:
    - interogate_vault_server:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${protocol + '://' + hostname + ':' + port + '/v1/secret/?list=true'}"
            - auth_type: anonymous
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - keystore: '${keystore}'
            - keystore_password: '${keystore_password}'
            - content_type: application/json
            - proxy_password: '${proxy_password}'
            - headers: "${'X-VAULT-Token: ' + x_vault_token}"
        publish:
          - return_result: '${return_result}'
          - return_code: '${return_code}'
          - error_message: '${error_message}'
          - status_code: '${status_code}'
          - response_headers: '${response_headers}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: .keys
        publish:
          - keys: "${''.join( c for c in return_result if  c not in '\"[]' )}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - keys: '${keys}'
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - status_code: '${status_code}'
    - error_message: '${error_message}'
    - response_headers: '${response_headers}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      interogate_vault_server:
        x: 113
        y: 100
      json_path_query:
        x: 316
        y: 102
        navigate:
          f7d314f2-1480-e2ff-1237-f0ce00d7995c:
            targetId: 17f1e303-4855-913c-223b-61d82c44a815
            port: SUCCESS
    results:
      SUCCESS:
        17f1e303-4855-913c-223b-61d82c44a815:
          x: 529
          y: 92

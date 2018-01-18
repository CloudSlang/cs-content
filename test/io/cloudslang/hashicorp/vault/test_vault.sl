#   (c) Copyright 2017 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: A master flow to test flows and operations from hashicorp/vault folder.
#!
#! @input hostname: Vault's FQDN.
#! @input port: Vault's Port.
#! @input x_vault_token: Vault's X-VAULT-Token.
#! @input keys: Vault's unseal keys of comma separated values.
#! @input secret: Vault's secret to be read and written by the flow.
#! @input secret_value: Vault's secret value to be written for the above secret.
#! @input trust_keystore: local trust keystore file.
#! @input trust_password: local trust keystore's password.
#!
#! @result SUCCESS: All commands completed successfully thus Vault interaction occured as:
#!                  seal status received, vault got unsealed, secrets list was retrieved,
#!                  particular secret was updated and read, vault was finally sealed.
#! @result FAILURE: Something went wrong. Most likely the return_result was not as expected.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.vault

imports:
  vault: io.cloudslang.hashicorp.vault

flow:
  name: test_vault

  inputs:
    - hostname
    - port
    - x_vault_token:
        sensitive: true
    - keys:
        sensitive: true
    - secret
    - secret_value:
        sensitive: true
    - trust_keystore
    - trust_password:
        sensitive: true

  workflow:
    - get_vault_status:
        do:
          vault.seal_unseal.get_seal_status:
            - hostname
            - port
            - trust_keystore
            - trust_password
        publish:
          - return_result
          - sealed
          - status_code
        navigate:
          - SUCCESS: unseal_vault
          - FAILURE: on_failure
    - unseal_vault:
        do:
          vault.seal_unseal.unseal_vault_now:
            - hostname
            - port
            - x_vault_token
            - keys
            - trust_keystore
            - trust_password
        publish:
          - return_result
          - status_code
        navigate:
          - SUCCESS: list_secrets
          - FAILURE: on_failure
    - list_secrets:
        do:
          vault.secrets.list_secrets:
            - hostname
            - port
            - x_vault_token
            - trust_keystore
            - trust_password
        publish:
          - return_result
          - keys
          - status_code
        navigate:
          - SUCCESS: write_secret
          - FAILURE: on_failure
    - write_secret:
        do:
          vault.secrets.write_secret:
            - hostname
            - port
            - x_vault_token
            - secret
            - secret_value
            - trust_keystore
            - trust_password
        publish:
          - return_result
          - status_code
        navigate:
          - SUCCESS: read_secret
          - FAILURE: on_failure
    - read_secret:
        do:
          vault.secrets.read_secret:
            - hostname
            - port
            - x_vault_token
            - secret
            - trust_keystore
            - trust_password
        publish:
          - return_result
          - secret_value
          - status_code
        navigate:
          - SUCCESS: seal_vault
          - FAILURE: on_failure
    - seal_vault:
        do:
          vault.seal_unseal.seal_vault:
            - hostname
            - port
            - x_vault_token
            - trust_keystore
            - trust_password
        publish:
          - return_result
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
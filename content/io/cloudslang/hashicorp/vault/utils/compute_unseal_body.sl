#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Gets one or two values and computes a json based output comprising 2 keys:
#!               key and reset which are part of the vault's unseal body.
#!               Example: '{"key":"value","reset":false}' where value is the provided unseal_key's value.
#!
#! @input unseal_key: A single master share key from Vault.
#!                    Optional
#! @input unseal_reset: Key used by Vault so that if true, the previously-provided unseal keys are discarded from memory and the unseal process is reset.
#!                      Format: Boolean.
#!                      Optional
#! @input computed_json: Private - Input used to define a default value of the computed json body as '{"reset":false}'.
#!                       Default: '{"reset":false}'
#!
#! @output return_result: response of operation in case of success, error message otherwise (a JSON based output similar to '{"key":"value","reset":false}')
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#!
#! @result SUCCESS: Flow completed successfully and return_result was computed as expected.
#! @result FAILURE: Failure occurred during the execution.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.vault.utils

imports:
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: compute_unseal_body

  inputs:
    - unseal_key:
        required: false
    - unseal_reset:
        required: false
    - computed_json:
        default: '{"reset":false}'
        private: true
        required: true

  workflow:
    - check_key_if_null:
        do:
          utils.is_null:
            - variable: '${unseal_key}'
        navigate:
          - IS_NULL: check_reset_if_null
          - IS_NOT_NULL: check_key_if_empty

    - check_key_if_empty:
        do:
          strings.string_equals:
            - first_string: '${unseal_key}'
            - second_string: ''
            - ignore_case: 'true'
        navigate:
          - SUCCESS: check_reset_if_null
          - FAILURE: add_key_value

    - check_reset_if_null:
        do:
          utils.is_null:
            - variable: '${unseal_reset}'
        navigate:
          - IS_NULL: SUCCESS
          - IS_NOT_NULL: check_reset_if_empty

    - check_reset_if_empty:
        do:
          strings.string_equals:
            - first_string: '${unseal_reset}'
            - second_string: ''
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: add_reset_value

    - add_key_value:
        do:
          json.add_value:
            - json_input: '{"key":"","reset":false}'
            - json_path: key
            - value: '${unseal_key}'
        publish:
          - computed_json: '${return_result}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: check_reset_if_null
          - FAILURE: on_failure

    - add_reset_value:
        do:
          json.add_value:
            - json_input: '${computed_json}'
            - json_path: reset
            - value: '${unseal_reset}'
        publish:
          - computed_json: '${return_result}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  outputs:
    - return_result: '${computed_json}'
    - return_code
    - error_message

  results:
    - SUCCESS
    - FAILURE
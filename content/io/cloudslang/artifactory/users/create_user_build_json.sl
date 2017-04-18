#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates a boot specific JSON object to be used when an OpenStack server is created
#! @input boot_index: the order in which a hyper-visor tries devices when it attempts to boot the guest from storage.
#!                    To disable a device from booting, the boot index of the device should be a negative value
#!                    - Default: '0'
#! @input uuid: uuid of the image to boot from - Example: 'b67f9da0-4a89-4588-b0f5-bf4d1940174'
#! @input source_type: the source type of the volume - Valid: "", "image", "snapshot" or "volume" - Default: ''
#! @input delete_on_termination: if True then the boot volume will be deleted when the server is destroyed, If false the
#!                               boot volume will be deleted when the server is destroyed.
#! @output json_output: the boot specific JSON object
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: "0" if success, "-1" otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: successfully created a boot specific JSON object (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.artifactory.users

imports:
  json: io.cloudslang.base.json

flow:
  name: create_user_build_json
  inputs:
     - user_name
     - user_password
     - user_email
     - json_string:
        default: ""
        overridable: false

  workflow:
    - create_empty_json:
        do:
          json.add_value:
            - json_input: "{}"
            - json_path: ['json_string']
            - value: ""
        publish:
          - user_create_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: add_profile_updatable
          - FAILURE: FAILURE

    - add_profile_updatable:
        do:
          json.add_value:
            - json_input: ${user_create_json}
            - json_path: ['profileUpdatable']
            - value: 'true'
        publish:
          - user_create_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: add_user_name
          - FAILURE: FAILURE

    - add_user_name:
        do:
          json.add_value:
            - json_input: ${user_create_json}
            - json_path: ['name']
            - value: ${user_name}
        publish:
          - user_create_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: add_user_email
          - FAILURE: FAILURE

    - add_user_email:
        do:
          json.add_value:
            - json_input: ${user_create_json}
            - json_path: ['email']
            - value: ${user_email}
        publish:
          - user_create_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: add_user_password
          - FAILURE: FAILURE

    - add_user_password:
        do:
          json.add_value:
            - json_input: ${user_create_json}
            - json_path: ['password']
            - value: ${user_password}
        publish:
          - user_create_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: add_user_retype_password
          - FAILURE: FAILURE

    - add_user_retype_password:
        do:
          json.add_value:
            - json_input: ${user_create_json}
            - json_path: ['retypePassword']
            - value: ${user_password}
        publish:
          - user_create_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

    - add_user_groups:
        do:
          json.add_value:
            - json_input: ${user_create_json}
            - json_path: ['userGroups']
            - value: '[]'
        publish:
          - user_create_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - user_create_json
    - return_result
    - return_code
    - error_message

  results:
    - SUCCESS
    - FAILURE
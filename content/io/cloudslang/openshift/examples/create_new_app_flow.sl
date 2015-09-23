#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates an embedded cartridge in OpenShift
# NOTE: This is experimental and while the app is created it cannot run yet
# WIP
#
# Inputs:
#   - cartridgeName - cartridge name
#   - applicationName - OpenShift application name
#   - scale - optional - Mark application as scalable. Value : true, false
#   - gear_size- optional - Size of the gear. Value : small, medium
#   - host - OpenShift host
#   - username - OpenShift username
#   - password - OpenShift username
#   - domain - OpenShift domain
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 202
#   - error_message: returnResult if statusCode != '202'
# Results:
#   - SUCCESS - operation succeeded (statusCode == '202')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openshift

namespace: io.cloudslang.openshift.examples

imports:
  openshift: io.cloudslang.openshift
  utils: io.cloudslang.base.utils
  print: io.cloudslang.base.print

flow:
  name: create_new_app_flow
  inputs:
    - cartridgeName
    - applicationName
    - scale
    - gear_size
    - host
    - username
    - password
    - domain
  workflow:
    - createapp:
        do:
          openshift.create_new_app:
            - cartridgeName
            - applicationName
            - scale
            - gear_size
            - host
            - username
            - password
            - domain
        publish:
          - return_result
          - error_message
          - response_body: return_result

    - convert_to_json:
        do:
          utils.convert_to_json:
            - json_as_string: response_body
        publish:
          - json_result

    - print_json:
        do:
          print.print_text:
            - text: json_result['data']['id']

    - scaleupapp:
        do:
          openshift.scale_up_app:
            - applicationId: json_result['data']['id']
            - host
            - username
            - password
        publish:
          - return_result
          - error_message

    - stopapp:
        do:
          openshift.stop_app:
            - applicationId: json_result['data']['id']
            - host
            - username
            - password
        publish:
          - return_result
          - error_message

    - startapp:
        do:
          openshift.start_app:
            - applicationId: json_result['data']['id']
            - host
            - username
            - password
        publish:
          - return_result
          - error_message

    - restartapp:
        do:
          openshift.restart_app:
            - applicationId: json_result['data']['id']
            - host
            - username
            - password
        publish:
          - return_result
          - error_message

    - deleteapp:
        do:
          openshift.delete_app:
            - applicationId: json_result['data']['id']
            - host
            - username
            - password
            - domain
        publish:
          - return_result
          - error_message
          - response_body: return_result

  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS
    - FAILURE


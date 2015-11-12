#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs an REST API call in order to power on a Virtual Machine in Nutanix PRISM
#
# Inputs:
#   - host - Nutanix host or IP Address endpoint
#   - username - the Nutanix username - Example: admin
#   - password - the Nutanix used for authentication
#   - proxy_host - optional - proxy server used to access the Nutanix host
#   - proxy_port - optional - proxy server port - Default: "'8080'"
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxy_username> input value
#   - vm_id - Id of the Virtual Machine to power on
#   - body - optional - JSON body containing Logical timestamp of the VM and host UUID (create.dto.acropolis.RequestValueDTO).
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if statusCode is not "201"
#   - return_code - "0" if success, "-1" otherwise
#   - status_code - the code returned by the operation
####################################################

namespace: io.cloudslang.nutanix

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: beta_vms_power_on
  inputs:
    - host
    - username
    - password
    - proxy_host:
        required: false
    - proxy_port:
        default: "'8080'"
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - vm_id

  workflow:
    - power_on_vm:
        do:
          rest.http_client_post:
            - url: "'https://' + host + '/vms/' + vm_id + '/power_op/on'"
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - content_type: "'application/json'"
            - headers: "'Accept: application/json'"
            - body
        publish:
          - return_result
          - error_message
          - return_code
          - status_code

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
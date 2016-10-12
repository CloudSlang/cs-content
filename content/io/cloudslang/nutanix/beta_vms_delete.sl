#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: This flow performs an REST API call in order to delete a Virtual Machine in Nutanix PRISM
#!
#! @input host: Nutanix host or IP Address endpoint
#! @input username: the Nutanix username - Example: admin
#! @input password: the Nutanix used for authentication
#! @input proxy_host: optional - proxy server used to access the Nutanix host
#! @input proxy_port: optional - proxy server port - Default: "'8080'"
#! @input proxy_username: optional - user name used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input vm_id: Id of the Virtual Machine to delete
#!
#! @output return_result: the response of the operation in case of success, the error message otherwise
#! @output error_message: return_result if statusCode is not "201"
#! @output return_code: "0" if success, "-1" otherwise
#! @output status_code: the code returned by the operation
#!
#! @result SUCCESS: Nutanix virtual machine deleted successfully
#! @result FAILURE: something went wrong
#!!#
####################################################

namespace: io.cloudslang.nutanix

imports:
  http: io.cloudslang.base.http

flow:
  name: beta_vms_delete
  inputs:
    - host
    - username
    - password
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - vm_id

  workflow:
    - delete_vm:
        do:
          http.http_client_delete:
            - url: ${'https://' + host + '/vms/' + vm_id}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - content_type: 'application/json'
            - headers: 'Accept: application/json'
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

  results:
    - SUCCESS
    - FAILURE
#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Low level mechanism for directly removing entries in the catalog.
#! @input host: Consul agent host
#! @input consul_port: optional - Consul agent host port - Default: '8500'
#! @input node: node name
#! @input datacenter: optional - Default: ''; matches that of the agent
#! @input service: optional - if Service key is provided, then service will also be registered - Default: ''
#! @input check: optional - if Check key is provided, then a health check will also be registered- Default: ''
#! @output error_message: return_result if there was an error
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.consul

imports:
  consul: io.cloudslang.consul

flow:
  name: deregister_endpoint
  inputs:
    - host
    - consul_port:
        default: '8500'
        required: false
    - node
    - datacenter:
        default: ''
        required: false
    - service:
        default: ''
        required: false
    - check:
        default: ''
        required: false
  workflow:
    - parse_register_endpoint_request:
        do:
          consul.parse_register_endpoint_request:
            - node
            - datacenter
            - service
            - check
        publish:
          - json_request

    - send_register_endpoint_request:
        do:
          consul.send_deregister_endpoint_request:
            - host
            - consul_port
            - json_request
        publish:
          - error_message

  outputs:
      - error_message
  results:
      - SUCCESS
      - FAILURE

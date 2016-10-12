#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Registers an endpoint to add a new agent service.
#! @input host: Consul agent host
#! @input consul_port: optional - Consul agent host port - Default: '8500'
#! @input address: optional - will default to that of the agent
#! @input service_name: the service name what will be registered
#! @input service_id: optional - if omitted, service_name will be used instead
#! @input check: optional - if the Check key is provided, then a health check will also be registered
#! @output error_message: return_result if there was an error
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.consul

imports:
  consul: io.cloudslang.consul

flow:
  name: register_agent_service
  inputs:
    - host
    - consul_port:
        default: '8500'
        required: false
    - address:
        required: false
    - service_name
    - service_id:
        required: false
    - check:
        required: false
  workflow:
    - parse_register_agent_service_request:
        do:
          consul.parse_register_agent_service_request:
            - address
            - service_name
            - service_id
            - check
        publish:
          - json_request
    - send_register_agent_service_request:
        do:
          consul.send_register_agent_service_request:
            - host
            - consul_port
            - json_request
        publish:
          - error_message
  outputs:
    - error_message

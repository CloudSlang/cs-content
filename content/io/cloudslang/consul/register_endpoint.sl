#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Directly register or update entries in the catalog.
#
# Inputs:
#   - host - Consul agent host
#   - consul_port - optional - Consul agent host port - Defualt: 8500
#   - node - node name
#   - address - node host
#   - datacenter - optional - Default: matched to that of agent
#   - service - optional - if Service key is provided, then service will also be registered
#   - check - optional - if the Check key is provided, then a health check will also be registered
# Outputs:
#   - errorMessage - returnResult if there was an error
# Results:
#   - SUCCESS - parsing was successful (returnCode == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.consul

imports:
  consul: io.cloudslang.consul
flow:
  name: register_endpoint
  inputs:
    - host
    - consul_port:
        default: "'8500'"
        required: false
    - node
    - address
    - datacenter:
        default: "''"
        required: false
    - service:
        default: "''"
        required: false
    - check:
        default: "''"
        required: false
  workflow:
    - parse_register_endpoint_request:
          do:
            consul.parse_register_endpoint_request:
                - node
                - address
                - datacenter
                - service
                - check
          publish:
            - json_request
    - send_register_endpoint_request:
        do:
          consul.send_register_endpoint_request:
              - host
              - consul_port
              - json_request
        publish:
            - errorMessage
  outputs:
      - errorMessage
  results:
      - SUCCESS
      - FAILURE
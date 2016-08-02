#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves parsed key data.
#! @input host: Consul agent host
#! @input consul_port: optional - Consul agent port - Default: '8500'
#! @input key_name: name of key to retrieve
#! @output decoded: parsed response
#! @output key: key name
#! @output flags: key flags
#! @output create_index: key create index
#! @output value: key value
#! @output modify_index: key modify index
#! @output lock_index: key lock index
#! @output error_message: return_result if there was an error
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.consul

imports:
  consul: io.cloudslang.consul

flow:
  name: report_kv
  inputs:
    - host
    - consul_port:
        default: "8500"
        required: false
    - key_name
  workflow:
    - retrieve_key:
        do:
          consul.get_kv:
            - key_name
            - host
            - consul_port
        publish:
          - return_result
    - parse_key:
        do:
          consul.parse_key:
            - json_response: ${return_result}
        publish:
          - decoded
          - key
          - flags
          - create_index
          - value
          - modify_index
          - lock_index
          - error_message
  outputs:
    - decoded
    - key
    - flags
    - create_index
    - value
    - modify_index
    - lock_index
    - error_message
  results:
    - SUCCESS
    - FAILURE

#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: The Entity Extraction API allows you to find useful snippets of information from a larger body of text.
#! @input api_key: The API key to use to authenticate the API request.
#! @input extract_entities_api:
#! @input text: The text content to process.
#! @input reference: A Haven OnDemand reference obtained from either the Expand Container or Store Object API. The corresponding document is passed to the API.
#! @input entity_type: The type of entity to extract from the specified text
#! @input show_alternatives: Set to true to return multiple entries when there are multiple matches for a particular string. For example London, UK and London, Ontario. Default value: false.
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @output result: result of The Add to Text Index API
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.ediscovery.entity_extraction

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  base: io.cloudslang.base.print

flow:
  name: entity_extraction

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.api_key')}
        sensitive: true
    - extract_entities_api: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.extract_entities_api')}
    - text:
        required: false
    - reference
    - entity_type:
         default: 'date_eng'
    - show_alternatives:
        required: false
        default: false
    - proxy_host:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.proxy_host')}
        required: false
    - proxy_port:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.proxy_port')}
        required: false

  workflow:

      - connect_to_server:
          do:
            http.http_client_post:
              - url: ${str(extract_entities_api) + '?reference=' + str(reference) + '&entity_type=' + str(entity_type) + '&show_alternatives=' + str(show_alternatives) + '&apikey=' + str(api_key)}
              - proxy_host
              - proxy_port

          publish:
              - error_message
              - return_result
              - return_code
          navigate:
             - SUCCESS: get_result_from_json
             - FAILURE: FAILURE

      - get_result_from_json:
          do:
            json.get_value:
              - json_input: ${return_result}
              - json_path: [entities,0]

          publish:
             - error_message
             - value: ${value if error_message == "" else " "}

          navigate:
            - SUCCESS: SUCCESS
            - FAILURE: no_entities

      - no_entities:
          do:
            json.get_value:
              - json_input: ${return_result}
              - json_path: [entities]

          publish:
           - error_message
           - value

      - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                       - text: ${str(error_message)}
  outputs:
      - result: ${value}
      - error_message

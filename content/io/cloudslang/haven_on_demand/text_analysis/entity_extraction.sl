#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Finds useful snippets of information from a larger body of text.
#! @input api_key: API key
#! @input reference: Haven OnDemand reference
#! @input entity_type: type of entity to extract from the specified text
#!                     optional
#!                     valid: Haven OnDemand entity type
#!                     default: people_eng
#! @input show_alternatives: set to true to return multiple entries when there
#!                           are multiple matches for a particular string
#!                           optional
#!                           default: false
#! @input proxy_host: proxy server
#!                    optional
#! @input proxy_port: proxy server port
#!                    optional
#! @output return_result: result of API
#! @output error_message: error message if one exists, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.text_analysis

imports:
  http: io.cloudslang.base.http
  print: io.cloudslang.base.print

flow:
  name: entity_extraction

  inputs:
    - api_key:
        sensitive: true
    - extract_entities_api:
        default: "https://api.havenondemand.com/1/api/sync/extractentities/v2"
        private: true
    - reference
    - entity_type:
        default: 'people_eng'
        required: false
    - show_alternatives:
        default: false
        required: false
    - proxy_host:
        required: false
    - proxy_port:
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
    - on_failure:
        - print_fail:
            do:
              print.print_text:
                - text: ${"Error - " + error_message}
  outputs:
    - error_message
    - return_result

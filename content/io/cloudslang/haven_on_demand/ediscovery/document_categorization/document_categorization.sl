#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: The Document Categorization API allows you to categorize documents according to a set of categories that you create.
#! @input api_key: The API key to use to authenticate the API request.
#! @input document_categorization_api:
#! @input reference: A Haven OnDemand reference obtained from either the Expand Container or Store Object API. The corresponding document is passed to the API.
#! @input field_text: A field restriction against the categorization index. Typically, this is a match against a parametric type field in the categories.
#! @input index: The name of the Haven OnDemand text index that you want to search for matching categories. This text index must be of the Categorization flavor.
#! @input max_results: The maximum number of categories to return for this document from the total number of results matched. Default value: 6.
#! @input print_value: The types of fields and content to display in the results. Default value: fields.
#! @input print_fields: The names of fields to print in the results.
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @output additional_info: result of The Add to Text Index API
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.ediscovery.document_categorization

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  base: io.cloudslang.base.print

flow:
  name: document_categorization

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.api_key')}
        sensitive: true
    - document_categorization_api: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.document_categorization_api')}
    - reference
    - field_text:
        default: ""
        required: false
    - index
    - max_results:
        default: 6
    - print_value:
        default: "fields"
        required: false
    - print_fields:
        default: ""
        required: false
    - proxy_host:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.proxy_host')}
        required: false
    - proxy_port:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.proxy_port')}
        required: false

  workflow:
      - connect_to_server:
          do:
            http.http_client_action:
              - url: ${str(document_categorization_api)}
              - method: POST
              - proxy_host
              - proxy_port
              - multipart_bodies: ${"reference=" + str(reference) + "&index=" + str(index) + "&max_results=" + str(max_results) + "&print=" + str(print_value) + "&print_fields=" + str(print_fields) + "&apikey=" + str(api_key)}
          publish:
              - error_message
              - return_result
              - return_code
          navigate:
             - SUCCESS: get_additional_info_from_json
             - FAILURE: FAILURE

      - get_additional_info_from_json:
            do:
              json.get_value:
                 - json_input: ${return_result}
                 - json_path: [documents,0]
            publish:
               - error_message
               - additional_info: ${value}
            navigate:
                 - SUCCESS: SUCCESS
                 - FAILURE: no_additional_info

      - no_additional_info:
           do:
             json.get_value:
               - json_input: ${return_result}
               - json_path: [documents]

           publish:
              - error_message
              - additional_info: ${value}

      - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                       - text: ${str(error_message)}
  outputs:
      - additional_info
      - error_message

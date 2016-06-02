#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: The Get Parametric Values API retrieves the unique values that occur in a particular field, which you can use to provide faceted search.
#! @input api_key: The API key to use to authenticate the API request.
#! @input find_related_concepts_api:
#! @input field_name: A comma-separated list of field names to return values for.
#! @input document_count: 	Set to true to show the number of documents that contain a parametric tag value. Default value: true.
#! @input field_text: The fields that result documents must contain, and the conditions that these fields must meet for the documents to return as results.
#! @input indexs: The text index to use to perform the parametric search. Default value: [wiki_eng].
#! @input max_values: The maximum number of values to return for each matched field name, between 1 and a maximum of 10000 values. Default value: 100.
#! @input min_score: The minimum percentage relevance that results must have to the query to return. Default value: 0.
#! @input sort: The criteria to use for the result display order. By default, results are not sorted. Default value: off.
#! @input text: The query text. Default value: *.
#! @input query_profile: The name of the query profile that you want to apply.
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @output result: result of The Find Related Concepts API
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.ediscovery.analyze_data

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  file: io.cloudslang.base.files
  base: io.cloudslang.base.print

flow:
  name: get_parametric_values

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.api_key')}
        sensitive: true
    - get_parametric_values_api: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.get_parametric_values_api')}
    - field_name
    - document_count:
        required: false
        default: true
    - field_text:
        required: false
        default: ""
    - indexes
    - max_values:
        required: false
        default: 100
    - min_score:
        required: false
        default: 0
    - sort:
        required: false
        default: "off"
    - text:
        required: false
        default: '*'
    - query_profile:
        required: false
        default: ""
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
              - url: ${str(get_parametric_values_api) + '?field_name=' + str(field_name) + '&document_count='+ str(document_count) + '&field_text=' + str(field_text) + '&indexes=' + str(indexes) + '&max_values=' + str(max_values) +'&min_score=' + str(min_score) + '&sort=' + str(sort) + '&text=' + str(text) +'&query_profile=' + str(query_profile) + '&apikey=' + str(api_key)}
              - proxy_host
              - proxy_port

          publish:
              - error_message
              - return_result
              - return_code

       - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                      - text: "${error_message}"
  outputs:
      - error_message
      - result: ${return_result}

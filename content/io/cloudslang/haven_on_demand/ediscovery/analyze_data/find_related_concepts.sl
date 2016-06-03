#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: The Find Related Concepts API returns a list of the best terms and phrases in query result documents. You can use these terms and phrases to provide topic disambiguation, automatic query guidance, or dynamic thesaurus generation.
#! @input api_key: The API key to use to authenticate the API request.
#! @input find_related_concepts_api:
#! @input text: A Haven OnDemand reference obtained from either the Expand Container or Store Object API. The corresponding query text is passed to the API.
#! @input field_text: The query text.
#! @input indexs: Type the name of one or more Haven OnDemand text indexes to return only documents that are stored in these text indexes. You can use the public datasets, or your own text indexes.
#! @input max_date: The latest creation date or time that a document can have to return as a result
#! @input max_results: The maximum number of related concepts to return. Default value: 20.
#! @input min_date: The earliest creation date or time that a document can have to return as a result.
#! @input min_score: The minimum percentage relevance that results must have to the query to return. Default value: 0.
#! @input sample_size: The maximum number of documents to use to generate concepts. The maximum value is 500 for public datasets, and 10000 for your own text indexes. Default value: 250.
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
  name: find_related_concepts

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.api_key')}
        sensitive: true
    - find_related_concepts_api: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.find_related_concepts_api')}
    - text
    - field_text:
        required: false
        default: ""
    - indexes
    - max_date:
        default: ""
        required: false
    - max_results:
        required: false
        default: 20
    - min_date:
        default: ""
        required: false
    - min_score:
        required: false
        default: 0
    - sample_size:
        required: false
        default: 250
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
              - url: ${str(find_related_concepts_api) + '?text=' + str(text) + '&indexes=' + str(indexes) + '&max_date=' + str(max_date) + '&max_results=' + str(max_results) + '&min_date=' + str(min_date) + '&sample_size=' + str(sample_size) + '&apikey=' + str(api_key)}
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

#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: The Add to Text Index API allows you to add content to a text index that you have set up. The API indexes your content and makes it available for use in other APIs.
#! @input api_key: The API key to use to authenticate the API request.
#! @input add_to_text_index_api:
#! @input reference: A Haven OnDemand reference obtained from either the Expand Container or Store Object API. The corresponding document is passed to the API.
#! @input index: The name of the index to create.
#! @input additional_metadata: A JSON object containing additional metadata to add to the indexed documents. This option does not apply to JSON input.
#!                            To add metadata for multiple files, specify objects in order, separated by an empty object.
#! @input duplicate_mode: The method to use to handle duplicate documents. Default value: replace.
#! @input reference_prefix: A string to add to the start of the reference of documents that are extracted from a file.
#!                          To add a prefix for multiple files, specify prefixes in order, separated by a space.
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @output result: result of The Add to Text Index API
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.ediscovery.add_to_text_index

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  base: io.cloudslang.base.print

flow:
  name: add_to_text_index

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.api_key')}
        sensitive: true
    - add_to_text_index_api: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.add_to_text_index_api')}
    - reference
    - index
    - additional_metadata:
        default: ""
        required: false
    - duplicate_mode:
        default: ""
        required: false
    - reference_prefix:
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
              - url: ${str(add_to_text_index_api)}
              - method: POST
              - proxy_host
              - proxy_port
              - multipart_bodies: ${"reference=" + str(reference) + "&index=" + str(index) +"&additional_metadata=" + str(additional_metadata) +"&duplicate_mode=" + str(duplicate_mode) +"&reference_prefix=" + str(reference_prefix) + "&apikey=" + str(api_key)}
          publish:
              - error_message
              - return_result
              - return_code

      - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                        - text: ${str(error_message)}
  outputs:
      - error_message
      - result: ${return_result}

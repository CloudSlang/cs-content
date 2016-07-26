#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Adds content to an already existing text index.
#! @input api_key: API key
#! @input reference: Haven OnDemand reference
#!                   optional - exactly one of <reference>, <json> is required
#! @input json: JSON document to index
#!                   optional - exactly one of <reference>, <json> is required
#! @input index: name of the index to add to
#! @input additional_metadata: JSON object containing additional metadata to add
#!                             to the indexed documents. To add metadata for
#!                             multiple files, specify objects in order,
#!                             separated by an empty object.
#!                             optional
#! @input duplicate_mode: method to use to handle duplicate documents
#!                        optional
#!                        valid: duplicate, replace
#!                        default: replace
#! @input reference_prefix: string to add to the start of the reference of
#!                          documents that are extracted from a file.
#!                          To add a prefix for multiple files, specify prefixes
#!                          in order, separated by a space.
#!                          optional
#! @input proxy_host: proxy server
#!                    optional
#! @input proxy_port: proxy server port
#!                    optional
#! @output return_result: result of API
#! @output error_message: error message if one exists, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.unstructured_text_indexing

imports:
  http: io.cloudslang.base.http
  print: io.cloudslang.base.print

flow:
  name: add_to_text_index

  inputs:
    - api_key:
        sensitive: true
    - add_to_text_index_api:
        default: "https://api.havenondemand.com/1/api/sync/addtotextindex/v1"
        private: true
    - reference:
        required: false
    - json:
        required: false
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
        required: false
    - proxy_port:
        required: false

  workflow:
    - connect_to_server:
        do:
          http.http_client_post:
            - url: ${str(add_to_text_index_api)}
            - proxy_host
            - proxy_port
            - body: ${("reference=" + str(reference)) if reference else ("json=" + str(json)) + "&index=" + str(index) +"&additional_metadata=" + str(additional_metadata) +"&duplicate_mode=" + str(duplicate_mode) +"&reference_prefix=" + str(reference_prefix) + "&apikey=" + str(api_key)}
            - content_type: "application/x-www-form-urlencoded"
        publish:
            - error_message
            - return_result
    - on_failure:
        - print_fail:
            do:
              print.print_text:
                - text: ${"Error - " + str(error_message)}
  outputs:
    - error_message
    - return_result

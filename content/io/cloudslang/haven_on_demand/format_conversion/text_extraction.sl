#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Extracts metadata and text content from a file.
#! @input api_key: API Key
#! @input reference: Haven OnDemand reference
#! @input additional_metadata: JSON object containing additional metadata to add
#!                             to the extracted documents.
#!                             optional
#! @input extract_metadata: whether to extract metadata from the file.
#!                          optional
#!                          default: true
#! @input extract_text: whether to extract text from the file
#!                      optional
#!                      default: true
#! @input extract_xmlattributes: whether to extract XML attributes from the file.
#!                               optional
#!                               default: false
#! @input password: passwords to use to extract the files
#!                  optional
#! @input reference_prefix: string to add to the start of the reference of
#!                          documents that are extracted from a file. To add a
#!                          prefix for multiple files, specify prefixes in order,
#!                          separated by a space.
#!                          optional
#! @input proxy_host: proxy server
#!                    optional
#! @input proxy_port: proxy server port
#!                    optional
#! @output return_result: result of API
#! @output error_message: error message if one exists, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.format_conversion

imports:
  http: io.cloudslang.base.http
  print: io.cloudslang.base.print

flow:
  name: text_extraction

  inputs:
    - api_key:
        sensitive: true
    - text_extraction_api:
        default: "https://api.havenondemand.com/1/api/sync/extracttext/v1"
        private: false
    - reference
    - additional_metadata:
        default: ""
        required: false
    - extract_metadata:
        default: true
        required: false
    - extract_text:
        default: true
        required: false
    - extract_xmlattributes:
        default: false
        required: false
    - password:
        required: false
        sensitive: true
    - reference_prefix:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - connect_to_server:
        do:
          http.http_client_post:
            - url: ${str(text_extraction_api) + '?reference=' + str(reference) + '&additional_metadata=' + str(additional_metadata) + '&extract_metadata=' + str(extract_metadata) + '&extract_text=' + str(extract_text) + '&extract_xmlattributes=' + str(extract_xmlattributes) + '&password=' + str(password) + '&reference_prefix=' + str(reference_prefix) + '&apikey=' + str(api_key)}
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

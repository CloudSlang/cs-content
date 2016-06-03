#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: The Text Extraction API uses HPE KeyView to extract metadata and text content from a file that you provide.
#! @input api_key: user's API Keys
#! @input text_extraction_api:
#! @input file: The file that you want to extract text from.
#! @input reference: The file that you want to extract text from.
#! @input additional_metadata: A JSON object containing additional metadata to add to the extracted documents. This option does not apply to JSON input. To add metadata for multiple files, specify objects in order, separated by an empty object.
#! @input extract_metadata: Whether to extract metadata from the file. Default value: true.
#! @input extract_text: Whether to extract text from the file. Default value: true.
#! @input extract_xmlattributes: Whether to extract XML attributes from the file. If your content is in XML, you can set this parameter to true if you want to extract the contents of XML tag attributes.
#!                               For example, for the tag <xml element="value">My example text</xml>, it extracts value My example text. Set this parameter to false if you want to extract only the tag contents (in this case My example text). Note: the Text Extraction API never extracts the names of the XML tags. Default value: false.
#! @input password: Passwords to use to extract the files.
#! @input reference_prefix: A string to add to the start of the reference of documents that are extracted from a file. This option does not apply to JSON input. To add a prefix for multiple files, specify prefixes in order, separated by a space.
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @output document: result of The Text Extraction
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.ediscovery.text_extraction

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  base: io.cloudslang.base.print

flow:
  name: text_extraction

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.api_key')}
        sensitive: true
    - text_extraction_api: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.text_extraction_api')}
    - file:
       required: false
    - reference
    - additional_metadata:
        required: false
        default: ''
    - extract_metadata:
        required: false
        default: true
    - extract_metadata:
        required: false
        default: true
    - extract_text:
        required: false
        default: true
    - extract_xmlattributes:
        required: false
        default: false
    - password:
        required: false
    - reference_prefix:
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
            http.http_client_post:
              - url: ${str(text_extraction_api) + '?reference=' + str(reference) + '&additional_metadata=' + str(additional_metadata) + '&extract_metadata=' + str(extract_metadata) + '&extract_text=' + str(extract_text) + '&extract_xmlattributes=' + str(extract_xmlattributes) + '&password=' + str(password) + '&reference_prefix=' + str(reference_prefix) + '&apikey=' + str(api_key)}
              - proxy_host
              - proxy_port

          publish:
              - error_message
              - return_result
              - return_code
          navigate:
            - SUCCESS: get_document_from_json
            - FAILURE: FAILURE

      - get_document_from_json:
          do:
            json.get_value:
              - json_input: ${return_result}
              - json_path: [document]
          publish:
             - error_message
             - value

      - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                       - text: ${str(error_message)}
  outputs:
      - error_message
      - document: ${value if error_message=="" else ""}

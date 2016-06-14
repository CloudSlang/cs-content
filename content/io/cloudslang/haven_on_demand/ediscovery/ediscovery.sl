#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description:  E-Discovery solution is extracting and managing electronic records, using format conversion, Natural Language Processing, Text Analytics, and unstructured data processing APIs. It allows to search any information in your container files.
#!                In Demo example we search for flows in our ready-made content and the result, which contains name of flow and link on our repository, will be send over mail.
#! @input api_key: user's API Keys
#! @input categorization_index:
#! @input file: The file that you want to extract text from.
#! @input categorization_index: The name of the Haven OnDemand text index. This text index must be of the Categorization flavor.
#! @input standart_index: The name of the Haven OnDemand text index that you want to search for results.
#! @input file: The container file to expand.
#! @input search: The query text.
#! @input file_for_result: path to file, where rusults will be put.
#! @input hostname: The query text.
#! @input port: The query text.
#! @input from: The query text.
#! @input to: The query text.
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.ediscovery

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  base: io.cloudslang.base.print
  ediscovery: io.cloudslang.haven_on_demand.ediscovery
  mail: io.cloudslang.base.mail
  file: io.cloudslang.base.files

flow:
  name: ediscovery

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.api_key')}
        sensitive: true
    - categorization_index
    - standart_index
    - file: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.file')}
    - search
    - file_for_result
    - hostname: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.hostname')}
    - port: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.port')}
    - from: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.from')}
    - to: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.to')}

  workflow:

      - FORMAT CONVENSION:
          do:
            ediscovery.expand_container.expand_container:
               - api_key
               - file
          publish:
              - error_message: ${'step FORMAT CONVENSION was failed '+ str(error_message) if error_message!=None else ""}
              - return_code
              - references
          navigate:
            - SUCCESS: TEXT ANALIZE
            - FAILURE: FAILURE

      - TEXT ANALIZE:
            parallel_loop:
             for: reference in references
             do:
               text_analyze:
                  - api_key
                  - reference
                  - categorization_index
                  - standart_index
            publish:
               - error_message: ${'step TEXT ANALIZE was failed '+ str(error_message) if error_message!=None else ""}
            navigate:
               - SUCCESS: SEARCH
               - FAILURE: FAILURE

      - SEARCH:
          do:
            ediscovery.analyze_data.query_text_index:
                - api_key
                - text: ${search.replace(" ", "+")}
                - indexes: ${standart_index}
          publish:
             - references: ${references[1:]}
             - error_message: ${'step SEARCH was failed '+ str(error_message) if error_message!=None else ""}
          navigate:
            - SUCCESS: PRINT RESULTS
            - FAILURE: FAILURE

      - PRINT RESULTS:
          loop:
            for: reference in references
            do:
              get_results:
                 - api_key
                 - reference
          publish:
              - text_for_mail
              - error_message: ${'step PRINT RESULTS was failed ' + reference + str(error_message) if error_message!=None else ""}

      - read_from_file:
          do:
           file.read_from_file:
               - file_path: ${file_for_result}
          publish:
            - read_text

      - send_mail:
          do:
           mail.send_mail:
              - hostname
              - port
              - from
              - to
              - subject: "Open all content on our GitHub"
              - body: ${read_text}

      - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                       - text: ${str(error_message)}
  outputs:
      - read_text
      - error_message

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
#! @input api_key: user's API Keys
#! @input categorization_index:
#! @input file: The file that you want to extract text from.
#! @input categorization_index: The name of the Haven OnDemand text index. This text index must be of the Categorization flavor.
#! @input standart_index: The name of the Haven OnDemand text index that you want to search for results.
#! @input file: The container file to expand.
#! @input search: The query text.
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.ediscovery

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  base: io.cloudslang.base.print
  ediscovery: io.cloudslang.haven_on_demand.ediscovery

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
           loop:
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
                - text: ${search}
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
              print_result:
                 - api_key
                 - reference
            publish:
              - error_message: ${'step PRINT RESULTS was failed '+ str(error_message) if error_message!=None else ""}

      - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                       - text: ${str(error_message)}
  outputs:
      - error_message

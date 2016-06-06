#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description:   Extracting and managing electronic records, using format conversion, Natural Language Processing, Text Analytics, and unstructured data processing APIs.
#! @input api_key: user's API Keys
#! @input reference: A Haven OnDemand reference obtained from either the Expand Container or Store Object API. The corresponding document is passed to the API.
#! @input categorization_index: The name of the Haven OnDemand text index. This text index must be of the Categorization flavor.
#! @input standart_index: The name of the Haven OnDemand text index that you want to search for results.
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################
namespace: io.cloudslang.haven_on_demand.ediscovery

imports:
  json: io.cloudslang.base.json
  base: io.cloudslang.base.print
  ediscovery: io.cloudslang.haven_on_demand.ediscovery

flow:
  name: text_analyze

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.api_key')}
        sensitive: true
    - reference
    - categorization_index
    - standart_index

  workflow:

      - text_extraction:
          do:
            ediscovery.text_extraction.text_extraction:
                - api_key
                - reference

          publish:
              - error_message: ${'step text_extraction failed '+ error_message if error_message != None else ""}
              - document
              - return_code


      - entity_extraction:
           do:
              ediscovery.entity_extraction.entity_extraction:
                 - api_key
                 - reference
           publish:
              - error_message: ${"step entity_extraction failed "+ error_message if error_message!= None else ""}
              - date: ${result if error_message == "" else " "}

      - document_categorization:
            do:
               ediscovery.document_categorization.document_categorization:
                  - api_key
                  - reference
                  - index: ${categorization_index}

            publish:
              - error_message: ${'step document_categorization was failed '+ error_message if error_message!= None else ""}
              - additional_info
              - booleanrestriction

      - create_metadata_for_doc:
            do:
               ediscovery.create_metadata:
                  - value: ${[date,additional_info]}
            publish:
              - error_message: ${'step create_metadata_for_doc failed ' + error_message if error_message!= None else ""}
              - json_data: ${json_data}

      - unstructured text indexing:
           do:
             ediscovery.add_to_text_index.add_to_text_index:
                 - reference
                 - index: ${standart_index}
                 - additional_metadata: ${json_data}
           publish:
              - error_message: ${'step add_to_text_index was failed '+ str(error_message) if error_message!= None else ""}
              - result


      - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                      - text: "${error_message}"

  outputs:
      - error_message

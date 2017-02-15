#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
namespace: io.cloudslang.base.xml

imports:
  xml: io.cloudslang.base.xml

flow:
  name: test_insert_before

  inputs:
    - xml_document
    - xpath_element_query
    - xml_element
    - xpath_test_query

  workflow:
    - app_value:
        do:
          xml.insert_before:
            - xml_document
            - xpath_element_query
            - xml_element
        publish:
          - result_xml
        navigate:
          - SUCCESS: find_inserted
          - FAILURE: INSERT_FAILURE
    - find_inserted:
        do:
          xml.xpath_query:
            - xml_document: ${result_xml}
            - xpath_query: ${xpath_test_query}
        publish:
          - selected_value
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FIND_INSERTED_FAILURE

  outputs:
    - selected_value
  results:
    - SUCCESS
    - INSERT_FAILURE
    - FIND_INSERTED_FAILURE

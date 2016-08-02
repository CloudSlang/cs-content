#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.xml

imports:
  xml: io.cloudslang.base.xml

flow:
  name: test_append_child

  inputs:
    - xml_document
    - xpath_element_query
    - xml_element
    - xpath_test_query

  workflow:
    - app_value:
        do:
          xml.append_child:
            - xml_document
            - xpath_element_query
            - xml_element
        publish:
          - result_xml
        navigate:
          - SUCCESS: find_appended
          - FAILURE: APPEND_FAILURE
    - find_appended:
        do:
          xml.select:
            - xml_document: ${result_xml}
            - xpath_query: ${xpath_test_query}
        publish:
          - selected_value
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FIND_APPENDED_FAILURE

  outputs:
    - selected_value
  results:
    - SUCCESS
    - APPEND_FAILURE
    - FIND_APPENDED_FAILURE

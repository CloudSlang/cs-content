#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Appends a child to an XML element.
#!
#! @input xml_document: XML string to append a child in
#! @input xpath_element_query: XPATH query that results in an element or element
#!                             list, where child element will be appended
#! @input xml_element: child element to append
#! @input secure_processing: whether to use secure processing
#!                           optional
#!                           default: false
#! @output result_xml: given XML with child appended
#! @output return_result: exception in case of failure, success message otherwise
#! @output result_text: 'success' or 'failure'
#! @result SUCCESS: child was appended
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.xml

operation:
  name: append_child

  inputs:
    - xml_document
    - xmlDocument:
        default: ${get("xml_document", "")}
        private: true
    - xpath_element_query
    - xPathElementQuery:
        default: ${get("xpath_element_query", "")}
        private: true
    - xml_element
    - xmlElement:
        default: ${get("xml_element", "")}
        private: true
    - secure_processing:
        required: false
    - secureProcessing:
        default: ${get("secure_processing", "false")}
        private: true

  java_action:
    class_name: io.cloudslang.content.xml.actions.AppendChild
    method_name: execute

  outputs:
    - result_xml: ${resultXML}
    - return_result: ${returnResult}
    - result_text: ${result}

  results:
    - SUCCESS: ${result == 'success'}
    - FAILURE

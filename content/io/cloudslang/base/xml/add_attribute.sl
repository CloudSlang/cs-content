#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Adds an attribute to an XML element or replaces the value if the attribute already exists.
#!
#! @input xml_document: XML string in which to add attribute
#! @input xpath_element_query: XPATH query that results in an element or element
#!                             list, not an attribute
#! @input attribute_name: name of attribute to add or replace
#! @input value: value of attribute to add or replace with
#! @input secure_processing: whether to use secure processing
#!                           optional
#!                           default: false
#! @output result_xml: given XML with added attribute(s)
#! @output return_result: exception in case of failure, success message otherwise
#! @output result_text: 'success' or 'failure'
#! @result SUCCESS: attribute was added
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.xml

operation:
  name: add_attribute

  inputs:
    - xml_document
    - xmlDocument:
        default: ${get("xml_document", "")}
        private: true
    - xpath_element_query
    - xPathElementQuery:
        default: ${get("xpath_element_query", "")}
        private: true
    - attribute_name
    - attributeName:
        default: ${get("attribute_name", "")}
        private: true
    - value
    - secure_processing:
        required: false
    - secureProcessing:
        default: ${get("secure_processing", "false")}
        private: true

  java_action:
    class_name: io.cloudslang.content.xml.actions.AddAttribute
    method_name: execute

  outputs:
    - result_xml: ${resultXML}
    - return_result: ${returnResult}
    - result_text: ${result}

  results:
    - SUCCESS: ${result == 'success'}
    - FAILURE

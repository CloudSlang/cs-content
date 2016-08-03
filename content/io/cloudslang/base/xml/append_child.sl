#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
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
#! @input xml_document: XML string or file to append a child in
#! @input xml_document_source: xml document type
#!                             Default value: 'xmlString'
#!                             Accepted values: 'xmlString', 'xmlPath'
#! @input xpath_element_query: XPATH query that results in an element or element list, where child element will be appended
#! @input xml_element: child element to append
#! @input secure_processing: optional -  sets the secure processing feature
#!                           "http://javax.xml.XMLConstants/feature/secure-processing" to be true or false when parsing
#!                           the xml document or string. (true instructs the implementation to process XML securely.
#!                           This may set limits on XML constructs to avoid conditions such as denial of service attacks)
#!                           and (false instructs the implementation to process XML in accordance with the XML specifications
#!                           ignoring security issues such as limits on XML constructs to avoid conditions such as
#!                           denial of service attacks)
#!                           Default value: 'true'
#!                           Accepted values: 'true' or 'false'
#! @output result_xml: given XML with child appended
#! @output return_result: exception in case of failure, success message otherwise
#! @output return_code: 0 if success, -1 if failure
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
        required: false
        private: true
    - xml_document_source:
        required: false
    - xmlDocumentSource:
        default: ${get("xml_document_source", "xmlString")}
        private: true
    - xpath_element_query:
        required: false
    - xPathElementQuery:
        default: ${get("xpath_element_query", "")}
        required: false
        private: true
    - xml_element:
        required: false
    - xmlElement:
        default: ${get("xml_element", "")}
        required: false
        private: true
    - secure_processing:
        required: false
    - secureProcessing:
        default: ${get("secure_processing", "true")}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-xml:0.0.6'
    class_name: io.cloudslang.content.xml.actions.AppendChild
    method_name: execute

  outputs:
    - result_xml: ${resultXML}
    - return_result: ${returnResult}
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

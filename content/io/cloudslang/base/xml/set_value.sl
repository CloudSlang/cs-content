#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Sets the value of an existing XML element or attribute.
#!
#! @input xml_document: XML string or file in which to set an element or attribute value
#! @input xml_document_source: xml document type
#!                             Default value: 'xmlString'
#!                             Accepted values: 'xmlString', 'xmlPath'
#! @input xpath_element_query: XPATH query that results in an element or element
#!                             list to set the value of or an element or element
#!                             list containing the attribute to set the value of
#! @input attribute_name: name of attribute to set the value of if setting an
#!                        attribute value; leave empty if setting the value of
#!                        an element
#!                        optional
#! @input value: value to set for element or attribute
#! @input secure_processing: optional -  sets the secure processing feature
#!                           "http://javax.xml.XMLConstants/feature/secure-processing" to be true or false when parsing
#!                           the xml document or string. (true instructs the implementation to process XML securely.
#!                           This may set limits on XML constructs to avoid conditions such as denial of service attacks)
#!                           and (false instructs the implementation to process XML in accordance with the XML specifications
#!                           ignoring security issues such as limits on XML constructs to avoid conditions such as
#!                           denial of service attacks)
#!                           Default value: 'true'
#!                           Accepted values: 'true' or 'false'
#! @output result_xml: given XML with value set
#! @output return_result: exception in case of failure, success message otherwise
#! @output return_code: 0 if success, -1 if failure
#! @result SUCCESS: value was set
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.xml

operation:
  name: set_value

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
    - attribute_name:
        required: false
    - attributeName:
        default: ${get("attribute_name", "")}
        required: false
        private: true
    - value
    - secure_processing:
        required: false
    - secureProcessing:
        default: ${get("secure_processing", "true")}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-xml:0.0.6'
    class_name: io.cloudslang.content.xml.actions.SetValue
    method_name: execute

  outputs:
    - result_xml: ${resultXML}
    - return_result: ${returnResult}
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

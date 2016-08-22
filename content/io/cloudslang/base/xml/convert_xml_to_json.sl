#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Converts a JSON array or a JSON object to a XML document.
#!
#! @input xml: The XML document (in the form of a String).
#! @input text_elements_name: Specify custom property name for text elements. This will be used for elements that have attributes and text content.
#!                             Default value: _text
#! @input include_root: The flag for including the xml root in the resulted JSON.
#!                       Default value: true
#!                       Accepted values: true, false
#! @input include_attributes: The flag for including XML attributes in the resulted JSON
#!                             Default value: true
#!                             Accepted values: true, false
#! @input pretty_print: The flag for formatting the resulted XML. The newline character is '\n'
#!                       Default value: true
#!                       Accepted values: true, false
#! @input parsing_features: The list of XML parsing features separated by new line. The feature name - value must
#!                          be separated by empty space. Setting specific features this field could be used to avoid XML
#!                          security issues like "XML Entity Expansion injection" and "XML External Entity injection".
#!                          To avoid aforementioned security issues we strongly recommend to set this input to the following values:
#!                          http://apache.org/xml/features/disallow-doctype-decl true
#!                          http://xml.org/sax/features/external-general-entities false
#!                          http://xml.org/sax/features/external-parameter-entities false
#!                          When the "http://apache.org/xml/features/disallow-doctype-decl"
#!                           feature is set to "true" the parser will throw a FATAL ERROR if the incoming document contains a DOCTYPE declaration.
#!                          When the "http://xml.org/sax/features/external-general-entities"
#!                           feature is set to "false" the parser will not include external general entities.
#!                          When the "http://xml.org/sax/features/external-parameter-entities"
#!                           feature is set to "false" the parser will not include external parameter entities or the external DTD subset.
#!                          If any of the validations fails, the operation will fail with an error message describing the problem.
#!                          Default value:
#!                            http://apache.org/xml/features/disallow-doctype-decl true
#!                            http://xml.org/sax/features/external-general-entities false
#!                            http://xml.org/sax/features/external-parameter-entities false
#!
#! @output return_result: This is the primary output. The resulted JSON Document or JSON objects in form of a String.
#! @output return_code: 0 for success; -1 for failure.
#! @output namespaces_prefixes: The list of tag prefixes separated by delimiter.
#! @output namespaces_uris: The corresponding list of namespaces Uris separated by delimiter.
#!                         (They can be used as input for Convert JSON to XML Operation)
#!
#! @result SUCCESS: The operation completed as stated in the description.
#! @result FAILURE: The operation completed unsuccessfully.
#!!#
####################################################


namespace: io.cloudslang.base.xml

operation:
  name: convert_xml_to_json

  inputs:
    - xml:
        required: true
    - text_elements_name:
        required: false
    - textElementsName:
        default: ${get("text_elements_name", "_text")}
        required: false
        private: true
    - include_root_element:
        required: false
    - includeRootElement:
        default: ${get("include_root_element", "true")}
        required: false
        private: true
    - include_attributes:
        required: false
    - includeAttributes:
        default: ${get("include_attributes", "true")}
        required: false
        private: true
    - pretty_print:
        required: false
    - prettyPrint:
        default: ${get("pretty_print", "true")}
        required: false
        private: true
    - parsing_features:
        required: false
    - parsingFeatures:
        default: ${get("parsing_features", "http://apache.org/xml/features/disallow-doctype-decl true
                                            http://xml.org/sax/features/external-general-entities false
                                            http://xml.org/sax/features/external-parameter-entities false")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-xml:0.0.7'
    class_name: io.cloudslang.content.xml.actions.ConvertXmlToJson
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - namespaces_prefixes: ${namespacesPrefixes}
    - namespaces_uris: ${namespacesUris}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

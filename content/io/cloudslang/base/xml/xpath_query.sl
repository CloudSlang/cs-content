#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Selects from an XML document using an XPATH query.
#!
#! @input xml_document: XML string or file in which to query an xpath
#! @input xml_document_source: xml document type
#!                             Default value: 'xmlString'
#!                             Accepted values: 'xmlString', 'xmlPath'
#! @input xpath_query: xpath query
#! @input query_type: type of selection result from query
#!                    attribute value; leave empty if setting the value of
#!                    valid: 'node', 'nodelist' or 'value'
#!                    optional
#!                    default: 'nodelist'
#! @input delimiter: string to use as delimiter in case query_type is nodelist
#!                   optional
#!                   default: ','
#! @input secure_processing: optional -  sets the secure processing feature
#!                           "http://javax.xml.XMLConstants/feature/secure-processing" to be true or false when parsing
#!                           the xml document or string. (true instructs the implementation to process XML securely.
#!                           This may set limits on XML constructs to avoid conditions such as denial of service attacks)
#!                           and (false instructs the implementation to process XML in accordance with the XML specifications
#!                           ignoring security issues such as limits on XML constructs to avoid conditions such as
#!                           denial of service attacks)
#!                           Default value: 'true'
#!                           Accepted values: 'true' or 'false'
#! @output selected_value: value selected, no match found or empty if an error occurs
#! @output return_result: xpath queried successfully or empty otherwise
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: an exception in case of failure
#! @result SUCCESS: if return_code = 0
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.xml

operation:
  name: xpath_query

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
    - xpath_query
    - xPathQuery:
        default: ${get("xpath_query", "")}
        required: false
        private: true
    - query_type:
        required: false
    - queryType:
        default: ${get("query_type", "nodelist")}
        private: true
    - delimiter:
        required: false
        default: ','
    - secure_processing:
        required: false
    - secureProcessing:
        default: ${get("secure_processing", "true")}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-xml:0.0.6'
    class_name: io.cloudslang.content.xml.actions.XpathQuery
    method_name: execute

  outputs:
    - selected_value: ${selectedValue}
    - return_result: ${returnResult}
    - error_message: ${errorMessage}
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

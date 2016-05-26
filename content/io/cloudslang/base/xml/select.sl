#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
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
#! @input xml_document: XML string in which query
#! @input xpath_query: XPATH query
#! @input query_type: type of selection result from query
#!                    attribute value; leave empty if setting the value of
#!                    valid: 'node', 'nodelist' or 'value'
#!                    optional
#!                    default: 'node'
#! @input delimiter: string to use as delimiter in case query_type is nodelist
#!                   optional
#!                   default: ','
#! @input secure_processing: whether to use secure processing
#!                           optional
#!                           default: false
#! @output selected_value: value selected or empty if no value found
#! @output return_result: exception in case of failure, success message otherwise
#! @output result_text: 'success' or 'failure'
#! @result SUCCESS: value was selected
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.xml

operation:
  name: select

  inputs:
    - xml_document
    - xmlDocument:
        default: ${get("xml_document", "")}
        private: true
    - xpath_query
    - xPathQuery:
        default: ${get("xpath_query", "")}
        private: true
    - query_type:
        required: false
    - queryType:
        default: ${get("query_type", "node")}
        private: true
    - delimiter:
        required: false
        default: ','
    - secure_processing:
        required: false
    - secureProcessing:
        default: ${get("secure_processing", "false")}
        private: true

  java_action:
    class_name: io.cloudslang.content.xml.actions.Select
    method_name: execute

  outputs:
    - selected_value: ${selectedValue}
    - return_result: ${returnResult}
    - result_text: ${result}

  results:
    - SUCCESS: ${result == 'success'}
    - FAILURE

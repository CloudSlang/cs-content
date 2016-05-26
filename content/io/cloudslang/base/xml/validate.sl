#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Tests an XML string for well-formedness and validates it against an XSD if given.
#!
#! @input xml_document: XML string to test
#! @input xsd_document: XSD to test given XML against
#!                      optional
#! @output return_result: exception in case of failure, success message otherwise
#! @output result_text: 'success' or 'failure'
#! @result SUCCESS: XML is well-formed and is valid based on XSD if given
#! @result FAILURE: XML is not well-formed or is not valid based on given XSD
#!!#
####################################################

namespace: io.cloudslang.base.xml

operation:
  name: validate

  inputs:
    - xml_document
    - xmlDocument:
        default: ${get("xml_document", "")}
        private: true
    - xsd_document:
        required: false
    - xsdDocument:
        default: ${get("xsd_document", "")}
        private: true
    - secure_processing:
        required: false
    - secureProcessing:
        default: ${get("secure_processing", "false")}
        private: true

  java_action:
    class_name: io.cloudslang.content.xml.actions.Validate
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - result_text: ${result}

  results:
    - SUCCESS: ${result == 'success'}
    - FAILURE

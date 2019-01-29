#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Adds an attribute to an XML element or replaces the value if the attribute already exists.
#!
#! @input xml_document: XML string or file in which to add attribute.
#! @input xml_document_source: XML document type.
#!                             Valid: 'xmlString', 'xmlPath'
#!                             Default: 'xmlString'
#!                             Optional
#! @input xpath_element_query: XPATH query that results in an element or element list, not an attribute.
#! @input attribute_name: Name of attribute to add or replace.
#! @input value: Value of attribute to add or replace with.
#! @input secure_processing: Sets the secure processing feature.
#!                           "http://javax.xml.XMLConstants/feature/secure-processing" to be true or false when parsing
#!                           the xml document or string. (true instructs the implementation to process XML securely.
#!                           This may set limits on XML constructs to avoid conditions such as denial of service attacks)
#!                           and (false instructs the implementation to process XML in accordance with the XML
#!                           specifications ignoring security issues such as limits on XML constructs to avoid conditions
#!                           such as denial of service attacks)
#!                           Accepted: 'true' or 'false'
#!                           Default: 'true'
#!                           Optional
#!
#! @output result_xml: Given XML with added attribute(s).
#! @output return_result: Exception in case of failure, success message otherwise.
#! @output return_code: 0 if success, -1 if failure.
#!
#! @result SUCCESS: Attribute was added.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.xml

operation:
  name: add_attribute

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
    - xpath_element_query
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
    gav: 'io.cloudslang.content:cs-xml:0.0.11'
    class_name: io.cloudslang.content.xml.actions.AddAttribute
    method_name: execute

  outputs:
    - result_xml: ${resultXML}
    - return_result: ${returnResult}
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

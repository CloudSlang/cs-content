#   Copyright 2023 Open Text
#   This program and the accompanying materials
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
#! @description: Appends a child to an XML element.
#!
#! @input xml_document: XML string or file to insert element in
#! @input xml_document_source: xml document type
#!                             Default value: 'xmlString'
#!                             Accepted values: 'xmlString', 'xmlPath'
#! @input xpath_element_query: XPATH query that results in an element or element
#!                             list, where element will be inserted before
#! @input xml_element: element to insert
#! @input secure_processing: Optional -  sets the secure processing feature
#!                           "http://javax.xml.XMLConstants/feature/secure-processing" to be true or false when parsing
#!                           the xml document or string. (true instructs the implementation to process XML securely.
#!                           This may set limits on XML constructs to avoid conditions such as denial of service attacks)
#!                           and (false instructs the implementation to process XML in accordance with the XML specifications
#!                           ignoring security issues such as limits on XML constructs to avoid conditions such as
#!                           denial of service attacks)
#!                           Accepted: 'true' or 'false'
#!                           Default: 'true'
#!
#! @output result_xml: Given XML with element inserted.
#! @output return_result: exception in case of failure, success message otherwise
#! @output return_code: 0 if success, -1 if failure
#!
#! @result SUCCESS: Element was inserted.
#! @result FAILURE: An error occurred while trying to insert the element
#!!#
########################################################################################################################

namespace: io.cloudslang.base.xml

operation:
  name: insert_before

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
    gav: 'io.cloudslang.content:cs-xml:0.0.21'
    class_name: io.cloudslang.content.xml.actions.InsertBefore
    method_name: execute

  outputs:
    - result_xml: ${resultXML}
    - return_result: ${returnResult}
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
# @description: Edits an XML document.
#
# @input xml: The XML (in the form of a String).
# @input file_path: absolute or remote path of the XML file.
# @input action: the edit action to take place.
#                Valid values: delete, insert, append, subnode, move, rename, update.
# @input xpath_1: the XPath Query to be run. The changes take place at the resulting elements.
# @input xpath_2: the XPath Query to be run. For the move action the results of xpath1 are moved to the results of xpath2.
# @input value: the new value.
#               Examples: <newNode>newNodeValue</newNode> , <newNode newAttribute="newAttributeValue">newNodeValue</newNode>, new value.
# @input type: Defines on what should the changes take effect : the element, the value of the element or the attributes of the element.
#              Valid values: elem, text, attr
# @input name: the name of the attribute in case the selected type is 'attr' .
# @input parsing_features: the list of XML parsing features separated by new line (CRLF).
#                          The feature name - value must be separated by empty space.
#                          Setting specific features this field could be used to avoid XML security issues like
#                          "XML Entity Expansion injection" and "XML External Entity injection".
#                          To avoid aforementioned security issues we strongly recommend to set this input to the following values:
#                          http://apache.org/xml/features/disallow-doctype-decl true
#                          http://xml.org/sax/features/external-general-entities false
#                          http://xml.org/sax/features/external-parameter-entities false
#                          When the "http://apache.org/xml/features/disallow-doctype-decl" feature is set to "true"
#                          the parser will throw a FATAL ERROR if the incoming document contains a DOCTYPE declaration.
#                          When the "http://xml.org/sax/features/external-general-entities" feature is set to "false"
#                          the parser will not include external general entities.
#                          When the "http://xml.org/sax/features/external-parameter-entities" feature is set to "false"
#                          the parser will not include external parameter entities or the external DTD subset.
#                          If any of the validations fails, the operation will fail with an error message describing the problem.
#                          Default value:
#                          http://apache.org/xml/features/disallow-doctype-decl true
#                          http://xml.org/sax/features/external-general-entities false
#                          http://xml.org/sax/features/external-parameter-entities false
# @output return_result: this is the primary output. The edited XML.
# @output return_code: 0 for success; -1 for failure.
# @output exception: the exception message in case one occured.
# @result SUCCESS: The operation completed as stated in the description.
# @result FAILURE: The operation completed unsuccessfully.
#
# Examples:
# 1. The following is a valid xpath example for working with a XML that uses default namespace.
#    This example searches all "td" elements from the default namespace:
#    xml: <table xmlns="http://www.w3.org/TR/html4/">
#                <tr>
#                    <td>Apples</td>
#                    <td>Bananas</td>
#                 </tr>
#            </table>
#    xpath1: //*[namespace-uri()="http://www.w3.org/TR/html4/" and name()="td"]
#
# Notes:
# 1. For the delete action the following inputs are required: xml or filePath, xpath1, type and in case type is 'attr'
#    then name is also required (representing the attributes name). Delete action modifies the XML only for type 'elem' or attr'.
# 2. For the insert action the following inputs are required: xml or filePath, xpath1, value, type and in case type is 'attr'
#    then name is also required (representing the attributes name). For type 'elem' insert adds the node before
#    the resulting nodes of the XPath. For type 'text' insert adds the text before the text value of resulting nodes of the XPath.
# 3. For the append action the following inputs are required: xml or filePath, xpath1, value, type and in case type is 'attr'
#    then name is also required (representing the attributes name). For type 'elem' append adds the node after
#    the resulting nodes of the XPath. For type 'text' append adds the text after the text value of resulting nodes of the XPath.
# 4. For insert and append attributes the order is the default alphabetical.
# 5. For the subnode action the following inputs are required: xml or filePath, xpath1 and value.
# 6. For the move action the following inputs are required: xml or filePath, xpath1 and xpath2.
#    Move  action  modifies the XML only for type 'elem'.
# 7. For the rename action the following inputs are required: xml or filePath, xpath1, value, type and in case type is 'attr'
#    then name is also required (representing the attributes name). Rename action  modifies the XML only for type 'elem' or attr'.
# 8. For the update action the following inputs are required: xml or filePath, xpath1, value, type and in case type is 'attr'
#    then name is also required (representing the attributes name).
# 9. The World Wide Web Consortium (W3C) organization provides the XPath specification (http://www.w3.org).
# 10. XML using default namespace is also supported by this operation.
# 11. An element from the default namespace can be retrieved using a location path.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.xml

operation:
  name: edit_xml

  inputs:
    - xml:
        required: false
    - file_path:
        required: false
    - filePath:
        default: ${get("file_path", "")}
        required: false
        private: true
    - action
    - xpath_1
    - xpath1:
        default: ${get("xpath_1", "")}
        required: false
        private: true
    - xpath_2:
        required: false
    - xpath2:
        default: ${get("xpath_2", "")}
        required: false
        private: true
    - value:
        required: false
    - type:
        required: false
    - name:
        required: false
    - parsing_features:
        default: |
            'http://apache.org/xml/features/disallow-doctype-decl true
             http://xml.org/sax/features/external-general-entities false
             http://xml.org/sax/features/external-parameter-entities false'
        required: false
    - parsingFeatures:
        default: ${get("parsing_features", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-xml:0.0.6'
    class_name: io.cloudslang.content.xml.actions.EditXml
    method_name: xPathReplaceNode

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
#   Copyright 2024 Open Text
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
#! @description: Converts a JSON array or a JSON object to a XML document.
#!
#! @input json: The JSON array or object (in the form of a String).
#! @input pretty_print: The flag for formatting the resulted XML. If it is true the result
#!                      will contain tabs and newline ('\n') chars.
#!                      Accepted: true, false
#!                      Default: true
#! @input show_xml_declaration: The flag for showing the xml declaration
#!                              (<?xml version="1.0" encoding="UTF-8" standalone="yes"?>).
#!                              If this is true then rootTagName can't be empty.
#!                              Accepted: true, false
#!                              Default: false
#! @input root_tag_name: The XML tag name. If this input is empty you will get a list of XML elements.
#! @input default_json_array_item_name: Default XML tag name for items in a JSON array if there isn't a pair
#!                                      (array name, array item name) defined in jsonArraysNames and jsonArraysItemNames.
#!                                      Default: 'item'
#! @input json_arrays_names: The list of array names separated by delimiter.
#! @input json_arrays_item_names: The corresponding list of array item names separated by delimiter.
#! @input namespaces_prefixes: The list of tag prefixes separated by delimiter.
#! @input namespaces_uris: The corresponding list of namespaces uris separated by delimiter.
#! @input delimiter: The list separator
#!                   Default: ','
#!                   Optional
#!
#! @output return_result: This is the primary output. The resulted XML document or XML elements.
#! @output return_code: 0 for success; -1 for failure.
#!
#! @result SUCCESS: The operation completed as stated in the description.
#! @result FAILURE: The operation completed unsuccessfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.xml

operation:
  name: convert_json_to_xml

  inputs:
    - json
    - pretty_print:
        required: false
    - prettyPrint:
        default: ${get("pretty_print", "true")}
        required: false
        private: true
    - show_xml_declaration:
        required: false
    - showXmlDeclaration:
        default: ${get("show_xml_declaration", "false")}
        required: false
        private: true
    - root_tag_name:
        required: false
    - rootTagName:
        default: ${get("root_tag_name", "")}
        required: false
        private: true
    - default_json_array_item_name:
        required: false
    - defaultJsonArrayItemName:
        default: ${get("default_json_array_item_name", "item")}
        required: false
        private: true
    - json_arrays_names:
        required: false
    - jsonArraysNames:
        default: ${get("json_arrays_names", "")}
        required: false
        private: true
    - json_arrays_item_names:
        required: false
    - jsonArraysItemNames:
        default: ${get("json_arrays_item_names", "")}
        required: false
        private: true
    - namespaces_prefixes:
        required: false
    - namespacesPrefixes:
        default: ${get("namespaces_prefixes", "")}
        required: false
        private: true
    - namespaces_uris:
        required: false
    - namespacesUris:
        default: ${get("namespaces_uris", "")}
        required: false
        private: true
    - delimiter:
        default: ","
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-xml:0.0.23'
    class_name: io.cloudslang.content.xml.actions.ConvertJsonToXml
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

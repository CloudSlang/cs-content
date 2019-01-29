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
#! @description: This operation performs a XSL Transformation to transform a XML document into HTML.
#!
#! @input xml_document: Optional - the location of the XML document to transform. Can be a local file path, an HTTP URL,
#!                      or the actual xml to transform, as string. This is Optional as some stylesheets do not need
#!                      an XML document and can create output based on runtime parameters.
#! @input xsl_template: The location of the XSL stylesheet to use. Can be a local file path,
#!                       an HTTP URL or the actual template as string.
#! @input output_file: Optional - the local file to write the output of the transformation. If an output file is not
#!                     specified the output of the transformation will be returned as returnResult.
#! @input parsing_features: Optional - The list of XML parsing features separated by new line (CRLF).
#!                          The feature name - value must be separated by empty space.
#!                          Setting specific features this field could be used to avoid XML security issues like
#!                          "XML Entity Expansion injection" and "XML External Entity injection".
#!                          To avoid aforementioned security issues we strongly recommend to set this input to the following values:
#!                          http://apache.org/xml/features/disallow-doctype-decl true
#!                          http://xml.org/sax/features/external-general-entities false
#!                          http://xml.org/sax/features/external-parameter-entities false
#!                          When the "http://apache.org/xml/features/disallow-doctype-decl" feature is set to "true"
#!                          the parser will throw a FATAL ERROR if the incoming document contains a DOCTYPE declaration.
#!                          When the "http://xml.org/sax/features/external-general-entities" feature is set to "false"
#!                          the parser will not include external general entities.
#!                          When the "http://xml.org/sax/features/external-parameter-entities" feature is set to "false"
#!                          the parser will not include external parameter entities or the external DTD subset.
#!                          If any of the validations fails, the operation will fail with an error message describing the problem.
#!                          Default value:
#!                          'http://apache.org/xml/features/disallow-doctype-decl true
#!                          http://xml.org/sax/features/external-general-entities false
#!                          http://xml.org/sax/features/external-parameter-entities false'
#!
#! @output return_result: The output of the transformation, if no output file is specified.
#! @output return_code: 0 if success, -1 if failure
#! @output exception: exception in case of failure, empty otherwise
#!
#! @result SUCCESS: XSL transformation applied successfully
#! @result FAILURE: There was an error while trying to apply the XSL transformation to the XML string or file
#!!#
########################################################################################################################

namespace: io.cloudslang.base.xml

operation:
  name: apply_xsl_transformation

  inputs:
    - xml_document:
        default: ''
        required: false
    - xmlDocument:
        default: ${get("xml_document", "")}
        required: false
        private: true
    - xsl_template
    - xslTemplate:
        default: ${get("xsl_template", "")}
        required: false
        private: true
    - output_file:
        default: ''
        required: false
    - outputFile:
        default: ${get("output_file", "")}
        required: false
        private: true
    - parsing_features:
        default: |
            http://apache.org/xml/features/disallow-doctype-decl true
            http://xml.org/sax/features/external-general-entities false
            http://xml.org/sax/features/external-parameter-entities false
        required: false
    - parsingFeatures:
        default: ${get("parsing_features", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-xml:0.0.11'
    class_name: io.cloudslang.content.xml.actions.ApplyXslTransformation
    method_name: applyXslTransformation

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

#   (c) Copyright 2022 Micro Focus, L.P.
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
namespace: io.cloudslang.base.xml

imports:
  xml: io.cloudslang.base.xml

flow:
  name: test_append_child

  inputs:
    - xml_document
    - xpath_element_query
    - xml_element
    - xpath_test_query

  workflow:
    - app_value:
        do:
          xml.append_child:
            - xml_document
            - xpath_element_query
            - xml_element
        publish:
          - result_xml
        navigate:
          - SUCCESS: find_appended
          - FAILURE: APPEND_FAILURE
    - find_appended:
        do:
          xml.xpath_query:
            - xml_document: ${result_xml}
            - xpath_query: ${xpath_test_query}
        publish:
          - selected_value
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FIND_APPENDED_FAILURE

  outputs:
    - selected_value
  results:
    - SUCCESS
    - APPEND_FAILURE
    - FIND_APPENDED_FAILURE

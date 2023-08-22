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
#! @description: This operation checks if a text input is found in a PDF file.
#!
#! @input text: The value of the string to find in the PDF file.
#! @input ignore_case: Whether to ignore if characters of the text are lowercase or uppercase.
#!                     Valid values: 'true', 'false'
#!                     Default: 'false'
#!                     Optional
#! @input path_to_file: The full path to the PDF file.
#! @input password: Password used to decrypt the PDF file, in case it is protected.
#!                  Optional
#!
#! @output return_result: The number of occurrences of the text in the PDF file.
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure.
#! @output exception: In case of success response, this result is empty. In case of failure response, this result
#!                    contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: The operation completed successfully.
#! @result FAILURE: An error occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation:
  name: find_text_in_pdf

  inputs:
    - text
    - ignore_case:
        default: 'false'
        required: false
    - ignoreCase:
        default: ${get('ignore_case', '')}
        required: false
        private: true
    - path_to_file
    - pathToFile:
        default: ${get('path_to_file', '')}
        required: false
        private: true
    - password:
        required: false
        sensitive: true

  java_action:
    gav: 'io.cloudslang.content:cs-utilities:0.1.24-SNAPSHOT-115'
    class_name: 'io.cloudslang.content.utilities.actions.FindTextInPdf'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

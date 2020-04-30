#   (c) Copyright 2020 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: This operation merge multiple PDF files to a single PDF file.
#!
#! @input path_to_file: The full path to the new PDF file.
#! @input path_to_pdf_files: The list of PDF files separated by comma containing the full path of each PDF file.
#!
#! @output return_result: The path to the created PDF file.
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
  name: merge_pdf

  inputs:
    - path_to_file
    - pathToFile:
        default: ${get('path_to_file', '')}
        required: false
        private: true
    - path_to_pdf_files
    - pathsToPDFFiles:
        default: ${get('path_to_pdf_files', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-utilities:0.1.13-RC2'
    class_name: 'io.cloudslang.content.utilities.actions.MergePdfFiles'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
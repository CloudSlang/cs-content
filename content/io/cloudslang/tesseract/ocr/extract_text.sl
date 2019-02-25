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
#! @description: This operation extracts the text from a specified file given as input using Tesseract's OCR engine.
#!
#! @input file_path: The path of the file to be extracted. The file must be an image. Most common image formats are
#!                   supported.
#!                   Required
#! @input data_path: The path to the Tesseract data config directory. This directory can contain different configuration
#!                   files as well as trained language data files.
#!                   Optional
#! @input language: The language that will be used by the OCR engine. This input is taken into consideration only
#!                  when specifying the dataPath input as well.
#!                  Default: 'ENG'
#!                  Optional
#!
#! @output return_result: This will contain the extracted text.
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure.
#! @output exception: In case of success response, this result is empty.
#!                    In case of failure response, this result contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: The operation completed successfully.
#! @result FAILURE: An error occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.tesseract.ocr

operation:
  name: extract_text

  inputs:
    - file_path
    - filePath:
        default: ${get('file_path', '')}
        required: false
        private: true
    - data_path:
        required: false
    - dataPath:
        default: ${get('data_path', '')}
        required: false
        private: true
    - language:
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-tesseract:1.0.0-RC7'
    class_name: 'io.cloudslang.content.tesseract.actions.ExtractText'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

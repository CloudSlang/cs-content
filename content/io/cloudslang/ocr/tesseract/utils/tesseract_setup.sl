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
#! @description: This operation setup Tesseract config files.
#!
#! @input data_path: The path to a folder where OCR Tesseract configuration files will be created.
#!
#! @output return_code: 0 if success, -1 otherwise.
#! @output return_result: This will contain the extracted text.
#! @output data_path_output: The path to the tessdata folder that contains the tesseract config files.
#! @output exception: In case of success response, this result is empty. In case of failure response, this result
#!                    contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: Configuration files created successfully.
#! @result FAILURE: There was an error while trying to create configuration files.
#!!#
########################################################################################################################

namespace: io.cloudslang.ocr.tesseract.utils

operation:
  name: tesseract_setup

  inputs:
  - data_path
  - dataPath:
      default: ${get('data_path', '')}
      required: true
      private: true

  java_action:
    gav: 'io.cloudslang.content:cs-tesseract:1.0.0-SNAPSHOT'
    class_name: 'io.cloudslang.content.tesseract.actions.utils.TesseractSetup'
    method_name: 'execute'

  outputs:
  - return_code: ${get('returnCode', '')}
  - return_result: ${get('returnResult', '')}
  - data_path_output: ${get('dataPath', '')}
  - exception: ${get('exception', '')}

  results:
  - SUCCESS: ${returnCode=='0'}
  - FAILURE

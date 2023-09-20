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
#! @description: This operations can be used to setup the Tesseract configuration folder to a specific file system
#! location. By default the created folder contains the latest ENG trained data file available in 06.2019.
#!
#! There are three sets of .traineddata files on the Tesseract Github in the following locations:
#! https://github.com/tesseract-ocr/tessdata_best
#! https://github.com/tesseract-ocr/tessdata_fast
#! https://github.com/tesseract-ocr/tessdata
#!
#! In order to train your own .traineddata files you can follow the official Tesseract Documentation available at:
#! https://github.com/tesseract-ocr/tesseract/wiki/TrainingTesseract-4.00
#!
#! @input data_path: The path to a folder where CS Tesseract OCR configuration files will be created.
#!
#! @output return_code: 0 if success, -1 otherwise.
#! @output return_result: A message in case of success, or an error message in case of failure.
#! @output data_path_output: The path to the tessdata folder that contains the tesseract config files.
#! @output exception: In case of success response, this result is empty. In case of failure response, this result
#!                    contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: Configuration files created successfully.
#! @result FAILURE: There was an error while trying to create configuration files.
#!!#
########################################################################################################################

namespace: io.cloudslang.tesseract.ocr.utils

operation:
  name: tesseract_setup

  inputs:
  - data_path
  - dataPath:
      default: ${get('data_path', '')}
      required: true
      private: true

  java_action:
    gav: 'io.cloudslang.content:cs-tesseract:1.0.5'
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

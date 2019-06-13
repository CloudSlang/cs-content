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
#! @description: This operation extracts the text from a specified image, given as input, using the Google Tesseract
#! library.
#!
#! Tesseract works best on images which have a DPI of at least 300 dpi, so it may be beneficial to resize images.
#!
#! For information regarding setting up the prerequisites, where to obtain more trained models or how to train your own
#! please see the description of the tesseract_setup operation.
#!
#! @input file_path: The path to the file from where the text needs to be extracted.
#! @input data_path: The path to the tessdata folder that contains the tesseract config files.
#! @input language: The language that will be used by the Tesseract engine. This input is taken into consideration only when
#!                  specifying the dataPath input as well.
#!                  Default value: 'ENG'
#! @input text_blocks: If set to 'true' operation will return the text blocks extracted from image, formatted as JSON.
#!                     Valid values: false, true
#!                     Default value: false
#!                     Optional
#! @input deskew: Improve text recognition if an image does not have a normal text orientation(skewed image). If set to
#!                'true' the image will be rotated to the correct text orientation.
#!                Valid values: false, true
#!                Default value: false
#!                Optional
#!
#! @output return_code: 0 if success, -1 otherwise.
#! @output return_result: This will contain the extracted text.
#! @output text_string: The extracted text from image.
#! @output text_json: A json containing extracted blocks of text from image.
#! @output exception: In case of success response, this result is empty. In case of failure response, this result
#!                    contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: Text extracted successfully.
#! @result FAILURE: There was an error while trying to extract the text.
#!!#
########################################################################################################################

namespace: io.cloudslang.google.tesseract

operation:
  name: extract_text_from_image

  inputs:
  - file_path
  - filePath:
      default: ${get('file_path', '')}
      required: true
      private: true
  - data_path:
      required: true
  - dataPath:
      default: ${get('data_path', '')}
      required: true
      private: true
  - language:
      required: true
  - text_blocks:
      required: false
  - textBlocks:
      default: ${get('text_blocks', '')}
      required: false
      private: true
  - deskew:
      required: false

  java_action:
    gav: 'io.cloudslang.content:cs-tesseract:1.0.1-RC1'
    class_name: 'io.cloudslang.content.tesseract.actions.ExtractTextFromImage'
    method_name: 'execute'

  outputs:
  - return_code: ${get('returnCode', '')}
  - return_result: ${get('returnResult', '')}
  - text_string: ${get('textString', '')}
  - text_json: ${get('textJson', '')}
  - exception: ${get('exception', '')}

  results:
  - SUCCESS: ${returnCode=='0'}
  - FAILURE

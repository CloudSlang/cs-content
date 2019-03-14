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
#! @description: This operation converts a PDF file given as input and extracts the text using Tesseract's OCR library.
#!
#! @input file_path: The path to the PDF file from where the text needs to be extracted.
#! @input data_path: The path to the tessdata folder that contains the tesseract config files.
#! @input language: The language that will be used by the OCR engine. This input is taken into consideration only when
#!                  specifying the dataPath input as well.
#!                  Default value: 'ENG'
#! @input dpi: The DPI value when converting the PDF file to image.
#!             Default value: 300
#!             Optional
#! @input text_blocks: If set to 'true' operation will return a json containing text blocks extracted from image.
 #!                    Valid values: false, true
#!                     Default value: false
#!                     Optional
#! @input deskew: Improve text recognition if an image does not have a normal text orientation(skewed image). If set to
#!                'true' the image will be rotated to the correct text orientation.
#!                 Valid values: false, true
#!                 Default value: false
#!                 Optional
#! @input from_page: The starting page from where the text should be retrieved
#!                   Default value: 0
#!                   Optional
#! @input to_page: The last page from where the text should be retrieved
#!                 Default value: 0
#!                 Optional
#! @input page_index: A list of indexes from where the text should be retrieved
#!                    Default value: 0
#!                    Optional
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

namespace: io.cloudslang.ocr.tesseract

operation:
  name: extract_text_from_pdf

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
  - dpi:
      required: false
  - text_blocks:
      required: false
  - textBlocks:
      default: ${get('text_blocks', '')}
      required: false
      private: true
  - deskew:
      required: false
  - from_page:
      required: false
  - fromPage:
      default: ${get('from_page', '')}
      required: false
      private: true
  - to_page:
      required: false
  - toPage:
      default: ${get('to_page', '')}
      required: false
      private: true
  - page_index:
      required: false
  - PageIndex:
      default: ${get('page_index', '')}
      required: false
      private: true

  java_action:
    gav: 'io.cloudslang.content:cs-tesseract:1.0.0-RC9'
    class_name: 'io.cloudslang.content.tesseract.actions.ExtractTextFromPDF'
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

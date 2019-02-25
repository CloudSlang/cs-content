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
#! @input data_path: The path to the Tesseract data config directory. This directory can contain different configuration
#!                   files as well as trained language data files.
#!                   Optional
#! @input language: The language that will be used by the OCR engine. This input is taken into consideration only when
#!                  specifying the dataPath input as well.
#!                  Optional
#! @input dpi: The DPI value when converting the PDF file to image.
#!             Optional
#!
#! @output return_code: 0 if success, -1 otherwise.
#! @output return_result: This will contain the extracted text.
#! @output exception: In case of success response, this result is empty. In case of failure response, this result
#!                    contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: Text extracted successfully.
#! @result FAILURE: There was an error while trying to extract the text.
#!!#
########################################################################################################################

namespace: io.cloudslang.tesseract.ocr

operation:
  name: extract_text_from_pdf

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
  - dpi:
      required: false

  java_action:
    gav: 'io.cloudslang.content:cs-tesseract:1.0.0-RC7'
    class_name: 'io.cloudslang.content.tesseract.actions.ExtractTextFromPDF'
    method_name: 'execute'

  outputs:
  - return_code: ${get('returnCode', '')}
  - return_result: ${get('returnResult', '')}
  - exception: ${get('exception', '')}

  results:
  - SUCCESS: ${returnCode=='0'}
  - FAILURE

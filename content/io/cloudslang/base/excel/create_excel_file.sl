#   Copyright 2024 Open Text
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
#! @description: Creates a blank Excel spreadsheet document. The format of the document (XLS, XLSX or XLSM) depends on the extension used by the file.
#!               XLS, XLSX and XLSM formats are supported.
#!
#! @input excel_file_name: The absolute path to the new Excel document.
#!                         Example: C:\temp\test.xls
#! @input worksheet_names: The name of Excel worksheet or the list with delimited worksheet names. If this value is empty it will create Sheet1, Sheet2 and Sheet3.
#!                        Optional
#! @input delimiter: The character used to delimit worksheet names.
#!                   Default value: comma (,)
#!
#! @output return_result: This is the primary output. Returns a success or a failure message.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error creating the file.
#!
#! @result SUCCESS: A new Excel document is created successfully.
#! @result FAILURE: Failed to create a new Excel document.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.excel

operation:
  name: create_excel_file

  inputs:
    - excel_file_name
    - excelFileName:
        default: ${get('excel_file_name', '')}
        required: false
        private: true
    - worksheet_names:
        required: false
    - worksheetNames:
        default: ${get('worksheet_names', '')}
        required: false
        private: true
    - delimiter:
        required: false
        default: ','

  java_action:
    gav: 'io.cloudslang.content:cs-excel:0.0.9'
    class_name: 'io.cloudslang.content.excel.actions.CreateExcelFile'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

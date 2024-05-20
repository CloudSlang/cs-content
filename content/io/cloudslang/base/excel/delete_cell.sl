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
#! @description: Delete cell data at the specified row index and column index in an Excel document.
#!               XLS, XLSX and XLSM formats are supported.
#!
#! @input excel_file_name: The absolute path to the Excel document.
#!                         Example: C:\temp\test.xls
#! @input worksheet_name: The name of Excel worksheet.
#!                        Default value: Sheet1
#!                        Optional
#! @input row_index: A list of row indexes.
#!                   Example: 1:3, 10, 15:20,25
#!                   Default value: from the index of the first row to the index of the last row in the Excel worksheet.
#!                   Optional
#! @input column_index: A list of column indexes.
#!                      Example: 1:3, 10, 15:20,25
#!                      Default value: from 0 to the index of the last column in the Excel worksheet.
#!                      Optional
#!
#! @output return_result: This is the primary output. Returns the number of rows that were deleted.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error deleting excel data.
#!
#! @result SUCCESS: The cell data specified was deleted successfully.
#! @result FAILURE: Failed to delete the cell data specified.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.excel

operation:
  name: delete_cell

  inputs:
    - excel_file_name
    - excelFileName:
        default: ${get('excel_file_name', '')}
        required: false
        private: true
    - worksheet_name:
        default: 'Sheet1'
        required: false
    - worksheetName:
        default: ${get('worksheet_name', '')}
        required: false
        private: true
    - row_index:
        required: false
    - rowIndex:
        default: ${get('row_index', '')}
        required: false
        private: true
    - column_index:
        required: false
    - columnIndex:
        default: ${get('column_index', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-excel:0.0.11'
    class_name: 'io.cloudslang.content.excel.actions.DeleteCell'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

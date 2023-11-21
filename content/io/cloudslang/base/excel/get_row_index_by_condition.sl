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
#! @description: Retrieves row indexes if the row satisfies the specified condition in an Excel document.
#!               XLS, XLSX and XLSM formats are supported.
#!
#! @input excel_file_name: The absolute path to the new Excel document.
#!                         Example: C:\temp\test.xls
#! @input worksheet_name: The name of Excel worksheet.
#!                        Default value: Sheet1
#!                        Optional
#! @input has_header: If Yes, then the first row of the document is expected to be the header row.
#!                    Valid values: yes, no
#!                    Default value: yes
#!                    Optional
#! @input row_data: A delimited list of data.
#! @input first_row_index: The index of the first row in the Excel worksheet, including the header row.
#!                         Default value: 0
#!                         Optional
#! @input column_index_to_query: The column index to search in.
#! @input operator: operator - The math operators.
#!                  Valid values: ==, != for string comparison; ==, !=, <,<=,>,>= for numeric comparison.
#!                  Default value: ==
#!                  Optional
#! @input value: The value to search in the specified column. If left blank, it means an empty value.
#!
#! @output return_result: This is the primary result. Return a list of row indexes that satisfied the specified condition.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error while retrieving the row data.
#! @output rows_count: The number of the row indexes returned.
#!
#! @result SUCCESS: The row indexes were retrieved successfully.
#! @result FAILURE: Failed to retrieve the row indexes.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.excel

operation:
  name: get_row_index_by_condition

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
    - has_header:
        default: 'yes'
        required: false
    - hasHeader:
        default: ${get('has_header', '')}
        required: false
        private: true
    - first_row_index:
        default: '0'
        required: false
    - firstRowIndex:
        default: ${get('first_row_index', '')}
        required: false
        private: true
    - column_index_to_query:
        required: true
    - columnIndextoQuery:
        default: ${get('column_index_to_query', '')}
        required: false
        private: true
    - operator:
        required: false
        default: '=='
    - value:
        required: false


  java_action:
    gav: 'io.cloudslang.content:cs-excel:0.0.8'
    class_name: 'io.cloudslang.content.excel.actions.GetRowIndexByCondition'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}
    - rows_count:  ${get('rowsCount', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

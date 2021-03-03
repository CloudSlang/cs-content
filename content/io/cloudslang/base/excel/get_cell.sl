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
#! @description: Retrieves the cell data with specified row index and column index in an Excel document. 
#!               XLS, XLSX and XLSM formats are supported.
#!
#! @input excel_file_name: The absolute path to the new Excel document.
#!                         Example: c:\temp\test.xls
#! @input worksheet_name: The name of Excel worksheet.
#!                        Default: Sheet1
#!                        Optional
#! @input has_header: If yes, then the first row of the document is expected to be the header row.
#!                    Valid values: yes, no
#!                    Default value: yes
#!                    Optional
#! @input first_row_index: The index of the first row in the Excel worksheet, including the header row.
#!                         Default value: 0
#!                         Optional
#! @input row_index: A list of row indexes.
#!                   Examples: 1:3, 10, 15:20, 25
#!                   Default Value: from the index of the first row
#!                                  to the index of the last row with content in the Excel worksheet.
#!                   Optional
#! @input column_index: A list of column indexes.
#!                      Examples: 1:3, 10, 15:20, 25
#!                      Default value: from 0 to the index of the
#!                                     last column with content in the Excel worksheet.
#!                      Optional
#! @input row_delimiter: The delimiter used to separate the rows of the returnResult.
#!                       Default value: | (pipe)
#!                       Optional
#! @input column_delimiter: The delimiter used to separate the columns of the returnResult.
#!                          Default value: , (comma)
#!                          Optional
#!
#! @output return_result: This is the primary output. Returns the cell data retrieved from Excel document.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error while retrieving the cell data.
#! @output header: A delimited list of column names of data being returned if hasHeader is set to Yes. 
#! @output rows_count: The number of the rows returned.
#! @output columns_count: The number of the columns returned.
#!
#! @result SUCCESS: The cell data was retrieved successfully.
#! @result FAILURE: Failed to retrieve the cell data.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.excel

operation: 
  name: get_cell
  
  inputs: 
    - excel_file_name    
    - excelFileName: 
        default: ${get('excel_file_name', '')}  
        required: false 
        private: true 
    - worksheet_name:  
        required: false  
    - worksheetName: 
        default: ${get('worksheet_name', '')}  
        required: false 
        private: true 
    - has_header:  
        required: false  
    - hasHeader: 
        default: ${get('has_header', '')}  
        required: false 
        private: true 
    - first_row_index:  
        required: false  
    - firstRowIndex: 
        default: ${get('first_row_index', '')}  
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
    - row_delimiter:  
        required: false  
    - rowDelimiter: 
        default: ${get('row_delimiter', '')}  
        required: false 
        private: true 
    - column_delimiter:  
        required: false  
    - columnDelimiter: 
        default: ${get('column_delimiter', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-excel:0.0.2'
    class_name: 'io.cloudslang.content.excel.actions.GetCell'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
    - header: ${get('header', '')} 
    - rows_count: ${get('rowsCount', '')} 
    - columns_count: ${get('columnsCount', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE

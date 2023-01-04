########################################################################################################################
#!!
#! @description: Delete rows or columns of data at the specified indexes in a CSV document.
#!               CSV formats are supported.
#!
#! @input csv_file_name: The absolute path to the new CSV document.
#!                       Examples: c:\temp\test.csv
#! @input column_delimiter: The delimiter used to separate the columns of the input csv file and of the
#!                          returnResult.
#!                          Default value: , (comma)
#!                          Optional
#! @input row_index: The row index/indexes of the rows that will be removed.
#!                   Examples: 1, 4:8
#! @input column_index: The column index/indexes of the columns that will be removed.
#!                      Examples: 1, 4:8
#!
#! @output return_result: This is the primary output. Returns the number of rows that were affected.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error removing CSV data.
#!
#! @result SUCCESS: One or more rows of data were removed successfully.
#! @result FAILURE: Failed to remove rows of data from the CSV document.
#!!#
########################################################################################################################

namespace: io.cloudslang.csv.actions

operation:
  name: delete_data

  inputs:
    - csv_file_name
    - csvFileName:
        default: ${get('csv_file_name', '')}
        required: false
        private: true
    - column_delimiter:
        required: false
    - columnDelimiter:
        default: ${get('column_delimiter', '')}
        required: false
        private: true
    - row_index
    - rowIndex:
        default: ${get('row_index', '')}
        required: false
        private: true
    - column_index
    - columnIndex:
        default: ${get('column_index', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-csv:0.0.1-SNAPSHOT'
    class_name: 'io.cloudslang.content.csv.actions.DeleteData'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

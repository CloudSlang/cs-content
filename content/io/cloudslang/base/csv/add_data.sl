########################################################################################################################
#!!
#! @description: Adds rows or columns of data to a CSV document. This operation can be used to add/insert/update data to CSV files.
#!               A least one of the following must be provided: row_data or column_data.
#!               CSV formats are supported.
#!
#! @input csv_file_name: The absolute path to the new CSV document.
#!                       Examples: c:\temp\test.csv
#! @input row_data: A delimited list of data on rows.
#!                  Optional
#! @input row_index: A row index where the new rows should be inserted.
#!                   Examples: 1, 5
#!                   Default Value: after the last row
#!                   of the CSV file.
#!                   Optional
#! @input column_data: A delimited list of data on columns.
#!                     Optional
#! @input column_index: A column index where the new columns should be inserted.
#!                      Examples: 1, 5
#!                      Default Value: after the
#!                      last column of the CSV file.
#!                      Optional
#! @input column_delimiter: The delimiter used to separate the columns of the returnResult.
#!                          Default value: , (comma)
#!                          Optional
#! @input overwrite_data: True if existing data should be overwritten.
#!                        Default value: false
#!                        Optional
#!
#! @output return_result: This is the primary output. Returns the number of rows that were added.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error adding CSV data.
#!
#! @result SUCCESS: One or more rows of data were added successfully.
#! @result FAILURE: Failed to add rows of data to the CSV document.
#!!#
########################################################################################################################

namespace: io.cloudslang.csv.actions

operation:
  name: add_data

  inputs:
    - csv_file_name
    - csvFileName:
        default: ${get('csv_file_name', '')}
        required: false
        private: true
    - row_data:
        required: false
    - rowData:
        default: ${get('row_data', '')}
        required: false
        private: true
    - row_index:
        required: false
    - rowIndex:
        default: ${get('row_index', '')}
        required: false
        private: true
    - column_data:
        required: false
    - columnData:
        default: ${get('column_data', '')}
        required: false
        private: true
    - column_index:
        required: false
    - columnIndex:
        default: ${get('column_index', '')}
        required: false
        private: true
    - column_delimiter:
        required: false
    - columnDelimiter:
        default: ${get('column_delimiter', '')}
        required: false
        private: true
    - overwrite_data:
        required: false
    - overwriteData:
        default: ${get('overwrite_data', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-csv:0.0.1-SNAPSHOT'
    class_name: 'io.cloudslang.content.csv.actions.AddData'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

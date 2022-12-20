########################################################################################################################
#!!
#! @description: Generated description.
#!
#! @input csv_file_name: The absolute path to the new CSV document.
#!                       Examples: c:\temp\test.csv
#! @input row_data: A delimited list of data.
#! @input row_index: A row index where the new row should be inserted.
#!                   Examples: 1, 5
#!                   Default Value: after the last row of the CSV file.
#!                   Optional
#! @input row_delimiter: The delimiter used to separate the rows of the input csv file and of the returnResult.
#!                       Default value: \n (new line)
#!                       Optional
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
    - row_data
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

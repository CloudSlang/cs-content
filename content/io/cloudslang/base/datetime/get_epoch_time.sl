########################################################################################################################
#!!
#! @description: Checks the current date and time, and returns its representation as an Epoch (Unix) timestamp.
#!
#! @output return_result: Current date and time in timestamp format.
#! @output return_code: 0 for success and 1 for failure.
#!
#! @result SUCCESS: Date/time retrieved successfully.
#! @result FAILURE: Date/time could not be retrieved.
#!!#
########################################################################################################################
namespace: io.cloudslang.base.datetime
operation:
  name: get_epoch_time
  python_action:
    script: |-
      import time
      try:
          return_result = str(int(time.time()))
          return_code = '0'
      except:
          return_result = sys.exc_info()
          return_code = '1'
  outputs:
    - return_result
    - return_code
  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE

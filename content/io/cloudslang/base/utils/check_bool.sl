####################################################
# Extra utility operations for CloudSlang
# Ben Coleman, Sept 2015, v1.0
####################################################
# Check is boolean is true or false, use for flow control
#
# Inputs:
#   - check_bool - Boolean value to check
# Results:
#   - SUCCESS - check_bool is true
#   - FAILURE - check_bool is false
####################################################

namespace: io.cloudslang.base.utils

operation:
  name: check_bool
  inputs:
    - bool_value
  action:
    python_script: |
      pass
  results:
    - SUCCESS: bool_value == True
    - FAILURE: bool_value != True

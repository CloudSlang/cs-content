####################################################
# Chef content for CloudSlang
# Ben Coleman, Sept 2015, v1.0
####################################################
# Filter lines by regex or string, returning only lines that contain the regex 
####################################################

namespace: io.cloudslang.chef.utils

operation:
  name: filter_lines  
  inputs:
    - text
    - filter

  action:
    python_script: |
      import re
      res = re.findall('.*' + filter + '.*', text)
      filter_result = '\n'.join(res)

  outputs:
    - filter_result
  results:
    - SUCCESS
    - FAILURE

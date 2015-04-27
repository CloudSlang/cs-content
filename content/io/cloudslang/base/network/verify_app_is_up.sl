#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Checks if an application is up and running.
#
# Inputs:
#   - host - IP where the application is running
#   - port - port on which the application is listening
#   - attempts - attempts to reach host
#   - time_to_sleep - time in seconds to wait between attempts
# Outputs:
#   - error_message - timeout exceeded and application did not respond
# Results:
#   - SUCCESS - application is up
#   - FAILURE - application not responding or down
####################################################

namespace: io.cloudslang.base.network

operation:
  name: verify_app_is_up
  inputs:
    - host
    - port
    - attempts
    - time_to_sleep:
        default: 1
        required: false
  action:
    python_script: |
      import urllib2
      import time
      message = 'Application is not up after ' + str(attempts) + ' attempts to ping.'
      url = "http://" + host + ":" + port
      count = 0
      return_result = False
      while (( count < int(attempts) ) and ( not return_result )):
        try:
          result = urllib2.urlopen(url)
        except Exception :
          count = count + 1
          time.sleep(int(time_to_sleep))
        else:
            code = result.getcode()
            count = int(attempts)
            if code == 200 :
              return_result = True
              message = "Application is up"
  outputs:
    - output_message: message

  results:
    - SUCCESS: return_result
    - FAILURE


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
#   - max_seconds_to_wait - timeout
# Outputs:
#   - error_message - timeout exceeded and application did not respond
# Results:
#   - SUCCESS - application is up
#   - FAILURE - application not responding or down
####################################################

namespace: org.openscore.slang.base.network

operation:
  name: verify_app_is_up
  inputs:
    - host
    - port
    - max_seconds_to_wait
  action:
    python_script: |
      import urllib2
      import time
      url = "http://" + host + ":" + port
      count = 0
      return_result = False
      while (( count < max_seconds_to_wait ) and ( not return_result )):
        try:
          result = urllib2.urlopen(url)
        except Exception :
           count = count + 1
           time.sleep(1)
        else:
            code = result.getcode()
            count = max_seconds_to_wait
            if code == 200 :
              return_result = True
  outputs:
    - error_message: "'Application is not Up , after ' + count + ' attempts to ping .'"
  results:
    - SUCCESS: return_result
    - FAILURE


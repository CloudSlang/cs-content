#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks if an application is up and running.
#! @input ssl: specify whether the host is over SSL or not
#! @input host: IP where the application is running
#! @input port: port on which the application is listening
#! @input attempts: attempts to reach host
#! @input time_to_sleep: optional - time in seconds to wait between attempts - Default: 10
#! @input attempt_timeout: optional - timeout, in seconds, for each attempt - Default: false
#! @output output_message: message indicating whether app is up or not
#! @result SUCCESS: application is up
#! @result FAILURE: application not responding or down
#!!#
####################################################

namespace: io.cloudslang.base.network

operation:
  name: verify_app_is_up
  inputs:
    - ssl: 0
    - host
    - port
    - attempts: 1
    - time_to_sleep:
        default: 1
        required: false
    - attempt_timeout:
        default: 10
        required: false
  python_action:
    script: |
      import requests
      import time
      message = 'Application is not up after ' + str(attempts) + ' attempts to ping.'
      if ssl == '1':
        url = "https://" + host + ":" + port
      else:
        url = "http://" + host + ":" + port
      count = 0
      return_result = False
      while (( count < int(attempts) ) and ( not return_result )):
        try:
          result = requests.get(url, timeout=int(attempt_timeout))
        except Exception as e:
          count = count + 1
          time.sleep(int(time_to_sleep))
        else:
            code = result.status_code
            count = int(attempts)
            if code == 200 :
              return_result = True
              message = "Application is up"
  outputs:
    - output_message: ${ message }

  results:
    - SUCCESS: ${ return_result }
    - FAILURE

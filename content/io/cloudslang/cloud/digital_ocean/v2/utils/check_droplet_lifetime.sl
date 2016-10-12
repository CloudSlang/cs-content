#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Checks if a droplet's lifetime exceeds a given threshold.
#! @input creation_time_as_string: creation time (UTC timezone) of the droplet as a string value
#!                                 Format (used by DigitalOcean): 2015-09-27T18:47:19Z
#! @input threshold: threshold in minutes to compare the droplet's lifetime to
#! @output return_result: elapsed time in minutes in case of success, cause of the error in case of failure
#! @output return_code: 0 if parsing was successful, -1 otherwise
#! @result FAILURE: an error occurred
#! @result ABOVE_THRESHOLD: lifetime of droplet reached the threshold
#! @result BELOW_THRESHOLD: lifetime of droplet did not reach the threshold
#!!#
########################################################################################################

namespace: io.cloudslang.cloud.digital_ocean.v2.utils

operation:
  name: check_droplet_lifetime
  inputs:
    - creation_time_as_string
    - threshold
  python_action:
    script: |
      try:
        from datetime import datetime

        creation_time = datetime.strptime(creation_time_as_string, '%Y-%m-%dT%H:%M:%SZ')
        current_time = datetime.utcnow()
        elapsed_time = (current_time - creation_time).total_seconds() / 60

        above_threshold = elapsed_time >= threshold

        return_code = '0'
        return_result = str(elapsed_time)

        del creation_time # cleanup, so engine will not complain (datetime is not serializable)
        del current_time
      except Exception as ex:
        return_code = '-1'
        return_result = ex
  outputs:
    - return_result
    - return_code
  results:
    - FAILURE: ${return_code != '0'}
    - ABOVE_THRESHOLD: ${above_threshold}
    - BELOW_THRESHOLD

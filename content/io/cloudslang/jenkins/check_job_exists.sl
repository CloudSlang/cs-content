#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Checks if a job exists in Jenkins.
#
# Prerequisites: jenkinsapi Python module
#
# Inputs:
#   - url - URL to Jenkins
#   - job_name - name of job to check
#   - expected_status - true if job is expected to exist, false otherwise
# Outputs:
#   - exists - true if job exists
#   - result_message - operation results
# Results:
#   - EXISTS_EXPECTED: job was expected to exist and does exist
#   - EXISTS_UNEXPECTED: job was not expected to exist, but does exist
#   - NOT_EXISTS: job does not exist
#   - FAILURE: error occurred
####################################################
namespace: io.cloudslang.jenkins

operation:
  name: check_job_exists
  inputs:
    - url
    - job_name
    - expected_status
  action:
    python_script: |
      try:
        from jenkinsapi.jenkins import Jenkins
        j = Jenkins(url, '', '')

        exists = j.has_job(job_name)
        expected_status2 = expected_status in ['true', 'True', 'TRUE']

        return_code = '0'
        result_message = 'Success'

        result = ''
        if (exists == True) and (expected_status2 == True):
          result = 'EXISTS_EXPECTED'
        elif (exists == True) and (expected_status2 == False):
          result = 'EXISTS_UNEXPECTED'
        else:
          result = 'NOT_EXISTS'

      except:
        import sys
        return_code = '-1'
        result_message = 'Error checking job\'s existence: ' + job_name
        result = 'FAILURE'

  outputs:
    - exists
    - result_message

  results:
    - EXISTS_EXPECTED: result == 'EXISTS_EXPECTED'
    - EXISTS_UNEXPECTED: result == 'EXISTS_UNEXPECTED'
    - NOT_EXISTS: result == 'NOT_EXISTS'
    - FAILURE: result == 'FAILURE'

#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation checks if a job exists in Jenkins
#
#    Inputs:
#      - url - the URL to Jenkins
#      - job_name - the name of the job to check
#      - expected_status - true if the invoking flow expects the job to exist, false otherwise
#    Outputs:
#      - result_message - a string formatted message of the operation results
#      - exists - true is the job exists status equals to inputs
#    Results:
#      - EXISTS_EXPECTED: if operation result is 'EXISTS_EXPECTED'
#      - EXISTS_UNEXPECTED: if operation result is 'EXISTS_UNEXPECTED'
#      - NOT_EXISTS: if operation result is 'NOT_EXISTS'
#      - FAILURE: if operation result is 'FAILURE'
#
#
#   This opeation requires 'jenkinsapi' python module to be imported
#   Please refer README.md for more information
####################################################
namespace: org.openscore.slang.jenkins

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
        result_message = 'Error checking job\'s existance: ' + job_name
        result = 'FAILURE'

  outputs:
    - exists
    - result_message

  results:
    - EXISTS_EXPECTED: result == 'EXISTS_EXPECTED'
    - EXISTS_UNEXPECTED: result == 'EXISTS_UNEXPECTED'
    - NOT_EXISTS: result == 'NOT_EXISTS'
    - FAILURE: result == 'FAILURE'

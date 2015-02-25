#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#
#   This operation returns the build number of the latest build for a Jenkins job.
#
#    Inputs:
#      - url - the URL to Jenkins
#      - job_name - the name of the job to check
#    Outputs:
#      - result_message - a string formatted message of the operation results
#      - last_buildnumber - the number of the list build for the specified job
#    Results:
#      - SUCCESS - return code is 0
#      - FAILURE - otherwise
#
#
#   This opeation requires 'jenkinsapi' python module to be imported
#   Please refer README.md for more information
####################################################

namespace: org.openscore.slang.jenkins

operation:
  name: get_last_buildnumber
  inputs:
    - url
    - job_name
  action:
    python_script: |
      try:
        from jenkinsapi.jenkins import Jenkins
        j = Jenkins(url, '', '')

        job = j.get_job(job_name)
        last_buildnumber = job.get_last_buildnumber()
        return_code = '0'
        result_message = 'Success'
      except:
        return_code = '-1'
        result_message = 'Error while obtaining last build number for job: ' + job_name

  outputs:
    - last_buildnumber
    - result_message

  results:
    - SUCCESS: return_code == '0'
    - FAILURE

#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves the build number of the latest build for a Jenkins job.
#
# Prerequisites: jenkinsapi Python module
#
# Inputs:
#   - url - URL to Jenkins
#   - job_name - name of job to check
# Outputs:
#   - last_buildnumber - number of last build for the specified job
#   - result_message - operation results
# Results:
#   - SUCCESS - return code is 0
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.jenkins

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

#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Copies a Jenkins job into a new Jenkins job.
#
# Prerequisites: jenkinsapi Python module
#
# Inputs:
#   - url - URL to Jenkins
#   - job_name - name of job to copy
#   - new_job_name - name of job to copy to
# Outputs:
#   - result_message - operation results
# Results:
#   - SUCCESS - return code is 0
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.jenkins

operation:
  name: copy_job
  inputs:
    - url
    - job_name
    - new_job_name
  action:
    python_script: |
      try:
        from jenkinsapi.jenkins import Jenkins
        j = Jenkins(url, '', '')

        jobs = j.jobs
        jobs.copy(job_name, new_job_name)

        return_code = '0'
        result_message = 'Success'
      except:
        import sys
        return_code = '-1'
        result_message = 'Error while copying job: ' + job_name + ' to ' + new_job_name

  outputs:
    - result_message

  results:
    - SUCCESS: return_code == '0'
    - FAILURE

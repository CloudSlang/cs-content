#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Copies a Jenkins job into a new Jenkins job.
#! @prerequisites: jenkinsapi Python module
#! @input url: URL to Jenkins
#! @input job_name: name of job to copy
#! @input new_job_name: name of job to copy to
#! @output result_message: operation results
#! @result SUCCESS: return code is 0
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.jenkins

operation:
  name: copy_job
  inputs:
    - url
    - job_name
    - new_job_name
  python_action:
    script: |
      try:
        from jenkinsapi.jenkins import Jenkins
        j = Jenkins(url, '', '')

        jobs = j.jobs
        jobs.copy(job_name, new_job_name)

        return_code = '0'
        result_message = 'Success'
      except:
        return_code = '-1'
        result_message = 'Error while copying job: ' + job_name + ' to ' + new_job_name

  outputs:
    - result_message

  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE

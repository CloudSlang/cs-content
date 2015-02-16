#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation returns the build number of the latest build for a Jenkins job.
#
# url:             the URL to Jenkins
# job_name:        the name of the job to disable

namespace: org.openscore.slang.jenkins

operation:
  name: get_last_buildnumber:
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
        returnCode = '0'
        returnResult = 'Success'
      except:
        returnCode = '-1'
        returnResult = 'Error while obtaining last build number for job: ' + job_name

  outputs:
    - last_buildnumber
    - returnResult

  results:
    - SUCCESS: returnCode == '0'
    - FAILURE

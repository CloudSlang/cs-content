#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation enables a Jenkins job.
#
# url:             the URL to Jenkins
# job_name:        the name of the job to disable

namespace: org.openscore.slang.jenkins

operation:
  name: enable_job:
  inputs:
    - url
    - job_name
  action:
    python_script: |
      try:
        from jenkinsapi.jenkins import Jenkins
        j = Jenkins(url, '', '')

        job = j.get_job(job_name)
        job.enable()

        returnCode = '0'
        returnResult = 'Success'
      except:
        import sys
        returnCode = '-1'
        returnResult = 'Error while enabling job: ' + job_name

  outputs:
    - last_buildnumber
    - returnResult

  results:
    - SUCCESS: returnCode == '0'
    - FAILURE

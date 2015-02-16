#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation assigns a given SCM URL to a Jenkins job.
#
# url:             the URL to Jenkins
# job_name:        the name of the job to disable
# new_scm_url:     the SCM url to assign

namespace: org.openscore.slang.jenkins

operations:
  - modify_scm_url:
      inputs:
        - url
        - job_name
        - new_scm_url
      action:
        python_script: |
          try:
            from jenkinsapi.jenkins import Jenkins
            j = Jenkins(url, '', '')
            
            job = j.get_job(job_name)
            job.modify_scm_url(new_scm_url)
            
            returnCode = '0'
            returnResult = 'Success'
          except:
            import sys
            returnCode = '-1'
            returnResult = 'Error while modifying scm url for job: ' + job_name + ' to ' + new_scm_url

      outputs:
        - last_buildnumber
        - returnResult

      results:
        - SUCCESS: returnCode == '0'
        - FAILURE

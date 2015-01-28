#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation deletes a Jenkins job.
#
# url:             the URL to Jenkins
# job_name:        the name of the job to delete


namespace: org.openscore.slang.jenkins

operations:
  - delete_job:
      inputs:
        - url
        - job_name
      action:
        python_script: |
          try:
            from jenkinsapi.jenkins import Jenkins
            j = Jenkins(url, '', '')
            
            j.delete_job(job_name)            
            
            returnCode = '0'
            returnResult = 'Success'
          except:
            import sys
            returnCode = '-1'
            returnResult = 'Error deleting job: ' + job_name

      outputs:
        - exists
        - returnResult

      results:
        - SUCCESS: returnCode == '0'
        - FAILURE

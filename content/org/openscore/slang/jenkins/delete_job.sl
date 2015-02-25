#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#
#   This operation deletes a Jenkins job.
#
#    Inputs:
#      - url - the URL to Jenkins
#      - job_name - the name of the job to delete
#    Outputs:
#      - result_message - a string formatted message of the operation results
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
  name: delete_job
  inputs:
    - url
    - job_name
  action:
    python_script: |
      try:
        from jenkinsapi.jenkins import Jenkins
        j = Jenkins(url, '', '')

        j.delete_job(job_name)

        return_code = '0'
        result_message = 'Success'
      except:
        import sys
        return_code = '-1'
        result_message = 'Error deleting job: ' + job_name

  outputs:
    - result_message

  results:
    - SUCCESS: return_code == '0'
    - FAILURE

#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Assigns a given SCM URL to a Jenkins job.
#! @prerequisites: jenkinsapi Python module
#! @input url: URL to Jenkins
#! @input job_name: name of job
#! @input new_scm_url: SCM url to assign
#! @output result_message: operation results
#! @result SUCCESS: return code is 0
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.jenkins

operation:
  name: modify_scm_url
  inputs:
    - url
    - job_name
    - new_scm_url
  python_action:
    script: |
      try:
        from jenkinsapi.jenkins import Jenkins
        j = Jenkins(url, '', '')

        job = j.get_job(job_name)
        job.modify_scm_url(new_scm_url)

        return_code = '0'
        result_message = 'Success'
      except:
        return_code = '-1'
        result_message = 'Error while modifying scm url for job: ' + job_name + ' to ' + new_scm_url

  outputs:
    - result_message

  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE

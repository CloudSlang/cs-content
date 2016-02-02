#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates a Jenkins job.
#
# Prerequisites: jenkinsapi Python module
#
# Inputs:
#   - url - URL to Jenkins
#   - job_name - name of job to create
#   - config_xml - configuration xml used to create a Jenkins job, actual file must be passed not its path
# Outputs:
#   - result_message - operation results
# Results:
#   - SUCCESS - return code is 0
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.jenkins

operation:
  name: create_job
  inputs:
    - url
    - job_name
    - config_xml
  action:
    python_script: |
      try:
        from jenkinsapi.jenkins import Jenkins

        j = Jenkins(url)
        jobs = j.jobs
        job = jobs.create(job_name, config_xml)

        return_code = '0'
        result_message = 'Success'
      except IOError as e:
        print "Unexpected error:", e
        return_code = '-1'
        result_message = 'Error while creating job: ' + job_name

  outputs:
    - result_message

  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE

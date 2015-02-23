#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#
#   This flow "fixes" a Jenkins job: after copying a job, the job cannot be directly triggered
#   from the Jenkins UI because the "Build now" link is missing for whatever reason. This job fixes
#   this by disabling and enabling the job.
#
#    Inputs:
#      - url - the URL to Jenkins
#      - job_name - the name of the job to fix
####################################################

namespace: org.openscore.slang.jenkins

imports:
  jenkins_ops: org.openscore.slang.jenkins

flow:
  name: fix_job
  inputs:
    - url
    - job_name

  workflow:

    - disable_job:
        do:
          jenkins_ops.disable_job:
            - url: url
            - job_name: job_name

    - enable_job:
        do:
          jenkins_ops.enable_job:
            - url: url
            - job_name: job_name


#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: "Fixes" following issue in a Jenkins job by disabling and enabling the job.
#!               After copying a job, the job cannot be directly triggered from the Jenkins UI because the "Build now" link is missing.
#! @input url: the URL to Jenkins
#! @input job_name: the name of the job to fix
#!!#
####################################################

namespace: io.cloudslang.jenkins

imports:
  jenkins: io.cloudslang.jenkins

flow:
  name: fix_job
  inputs:
    - url
    - job_name

  workflow:

    - disable_job:
        do:
          jenkins.disable_job:
            - url
            - job_name

    - enable_job:
        do:
          jenkins.enable_job:
            - url
            - job_name

#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.jenkins

imports:
  jenkins: io.cloudslang.jenkins

flow:
  name: test_clone_job_for_branch
  inputs:
    - host
    - port:
        required: false
    - config_xml

  workflow:

    - create_jenkins_job:
        do:
          jenkins.create_job:
            - url: "'http://' + host + ':49165'"
            - job_name: "'job1'"
            - config_xml
        navigate:
          SUCCESS: clone_job
          FAILURE: FAIL_TO_CREATE_JOB

    - clone_job:
        do:
          jenkins.clone_job_for_branch:
            - url: "'http://' + host + ':49165'"
            - jnks_job_name: "'job1'"
            - jnks_new_job_name: "'job2'"
            - new_scm_url: "'123'"
            - delete_job_if_existing: "'true'"
            - email_host: "'host'"
            - email_port: "'25'"
            - email_sender: "'email@hp.com'"
            - email_recipient: "'email@hp.com'"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAIL_TO_CLONE_JOB

  results:
    - SUCCESS
    - FAILURE
    - FAIL_TO_CLONE_JOB
    - FAIL_TO_CREATE_JOB

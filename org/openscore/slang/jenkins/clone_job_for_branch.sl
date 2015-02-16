#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#
# This flow clones an existing Jenkins job and changes it's SCM URL.
# 
# Use case: as a build manager, after you created a new SCM branch, you want to clone your Jenkins builds, and you want to set
# the SCM URL of these clones to point to the new SCM branch.
#  
# e.g.
#
#  url:                    http://localhost:8090/
#  jnks_job_name:          trunk-project1
#  jnks_new_job_name:      branch-project1
#  new_scm_url:            http://localhost:8080/svn/hackaton-repo/branches/test-branch
#  delete_job_if_existing: true
#  email_host:             host name of an SMTP server to use when sending email_host
#  email_port:             port of the SMTP server
#  email_sender:           the sender's email address
#  email_recipient:        the recipient's email address
####################################################

namespace: org.openscore.slang.jenkins

imports:
  jenkins_ops: org.openscore.slang.jenkins
  base_mail: org.openscore.slang.base.mail

flow:
  name: clone_job_for_branch
  inputs:
    - url
    - jnks_job_name
    - jnks_new_job_name
    - new_scm_url
    - delete_job_if_existing
    - email_host
    - email_port
    - email_sender
    - email_recipient
  workflow:
    check_job_exists:
      do:
        jenkins_ops.check_job_exists:
          - url
          - job_name: jnks_new_job_name
          - expected_status: delete_job_if_existing
      navigate:
        EXISTS_EXPECTED: delete_job
        EXISTS_UNEXPECTED: fail_with_job_existing
        NOT_EXISTS: copy_job
        FAILURE: FAILURE

    delete_job:
      do:
        jenkins_ops.delete_job:
          - url
          - job_name: jnks_new_job_name

    copy_job:
      do:
        jenkins_ops.copy_job:
          - url
          - job_name: jnks_job_name
          - new_job_name: jnks_new_job_name
      publish:
        - result_message

    modify_scm_url:
      do:
        jenkins_ops.modify_scm_url:
          - url
          - job_name: jnks_new_job_name
          - new_scm_url
      publish:
        - result_message

    fix_job:
      do:
        jenkins_ops.fix_job:
          - url
          - job_name: jnks_new_job_name
      publish:
        - result_message
      navigate:
        SUCCESS: SUCCESS
        FAILURE: FAILURE

    fail_with_job_existing:
      do:
        base_mail.send_mail:
          - hostname: email_host
          - port: email_port
          - from: email_sender
          - to: email_recipient
          - subject: "'Flow failure'"
          - body: "'Job ' + jnks_new_job_name + ' is already existing.'"
      navigate:
        SUCCESS: FAILURE
        FAILURE: FAILURE

    on_failure:
      send_error_mail:
        do:
          base_mail.send_mail:
            - hostname: email_host
            - port: email_port
            - from: email_sender
            - to: email_recipient
            - subject: "'Flow failure'"
            - body: "'Operation failed: ' + result_message"
        navigate:
          SUCCESS: FAILURE
          FAILURE: FAILURE

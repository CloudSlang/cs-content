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
  images: io.cloudslang.docker.images
  containers: io.cloudslang.docker.containers
  maintenance: io.cloudslang.docker.maintenance
  base_utils: io.cloudslang.base.utils
  base_files: io.cloudslang.base.files

flow:
  name: test_clone_job_for_branch
  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - image_name
    - container_name
    - config_xml_path

  workflow:

    - clear_docker_host_prerequest:
       do:
         maintenance.clear_docker_host:
           - docker_host: host
           - port:
               required: false
           - docker_username: username
           - docker_password:
               default: password
               required: false
           - private_key_file:
               required: false
       navigate:
         SUCCESS: pull_image
         FAILURE: PREREQUEST_MACHINE_IS_NOT_CLEAN

    - pull_image:
        do:
          images.pull_image:
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - image_name
        navigate:
          SUCCESS: run_container
          FAILURE: FAIL_PULL_IMAGE

    - run_container:
        do:
          containers.run_container:
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - container_name
            - image_name
            - container_params:
                default: "'-p 49165:8080'"
                overridable: false
        navigate:
          SUCCESS: wait_till_jenkins_gets_up
          FAILURE: FAIL_RUN_IMAGE

    - wait_till_jenkins_gets_up:
        do:
          base_utils.sleep:
            - seconds: "'20'"
        navigate:
          SUCCESS: read_job_config_xml

    - read_job_config_xml:
        do:
          base_files.read_from_file:
            - file_path: config_xml_path
        publish:
          - read_text
        navigate:
          SUCCESS: create_jenkins_job
          FAILURE: FAIL_TO_READ_XML

    - create_jenkins_job:
        do:
          jenkins.create_job:
            - url: "'http://' + host + ':49165'"
            - job_name: "'job1'"
            - config_xml: read_text
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
          SUCCESS: SUCCESS #stop_container
          FAILURE: FAIL_TO_CLONE_JOB

    - stop_container:
        do:
          containers.stop_container:
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - container_id: container_name
        navigate:
          SUCCESS: SUCCESS #clear_docker_host
          FAILURE: FAIL_TO_STOP_CONTAINER

    - clear_docker_host:
        do:
         maintenance.clear_docker_host:
           - docker_host: host
           - port:
               required: false
           - docker_username: username
           - docker_password:
               default: password
               required: false
           - private_key_file:
               required: false
        navigate:
         SUCCESS: SUCCESS
         FAILURE: MACHINE_IS_NOT_CLEAN

  results:
    - SUCCESS
    - PREREQUEST_MACHINE_IS_NOT_CLEAN
    - MACHINE_IS_NOT_CLEAN
    - FAIL_PULL_IMAGE
    - FAILURE
    - FAIL_RUN_IMAGE
    - FAIL_TO_CLONE_JOB
    - FAIL_TO_CREATE_JOB
    - FAIL_TO_STOP_CONTAINER
    - FAIL_TO_READ_XML

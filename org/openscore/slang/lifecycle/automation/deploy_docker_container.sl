#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#

###############################################################################################################
# Create a Dockerfile on the remote machine, build an image from it, create and run a container from the image
#
# Inputs:
#    - artifact_uri - URI to a war file for Tomcat
#    - docker_machine_host - Docker machine host
#    - docker_machine_username - Docker machine username
#    - docker_machine_password - Docker machine password
#    - workdir - working directory inside Docker machine; the Dockerfile is created here;
#        if directory does not exist, it is created during the process
#    - docker_user - Docker username for creating images; it should be the same as the Docker Hub username
#    - image_name - name of the Docker image that is created
#    - version - version(tag) of the Docker image that is created
###############################################################################################################

namespace: org.openscore.slang.lifecycle.automation

imports:
 automation: org.openscore.slang.lifecycle.automation

flow:
  name: deploy_docker_container
  inputs:
    - artifact_uri
    - docker_machine_host
    - docker_machine_username
    - docker_machine_password
    - workdir
    - docker_user
    - image_name
    - version
  workflow:
    create_dockerfile:
      do:
        automation.create_dockerfile:
            - image_name:
                default: "'tomcat'"
                override: true
            - version:
                default: "'8.0'"
                override: true
            - artifact_uri
            - host: docker_machine_host
            - username: docker_machine_username
            - password: docker_machine_password
            - workdir

    create_image:
      do:
        automation.create_image:
            - docker_user
            - image_name
            - version
            - path_dockerfile: workdir
            - host: docker_machine_host
            - username: docker_machine_username
            - password: docker_machine_password

    create_and_run_container:
      do:
        automation.create_and_run_container:
            - docker_user
            - image_name
            - version
            - host: docker_machine_host
            - username: docker_machine_username
            - password: docker_machine_password

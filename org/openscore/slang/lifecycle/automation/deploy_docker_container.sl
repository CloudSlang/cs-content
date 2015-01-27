#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

####################################################

namespace: org.openscore.slang.lifecycle.automation

imports:
 automation: org.openscore.slang.lifecycle.automation

flow:
  name: deploy_docker_container
  inputs:
    - artifact_uri
    - host
    - username
    - password
    - workdir
    - docker_hub_user
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
            - host
            - username
            - password
            - workdir

    create_image:
      do:
        automation.create_image:
            - docker_hub_user
            - image_name
            - version
            - path_dockerfile: workdir
            - host
            - username
            - password


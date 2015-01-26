#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will create a docker db container.
#
#   Inputs:
#       - host - Docker machine host
#       - username - Docker machine username
#       - password - Docker machine password
#   Outputs:
#       - dbIp - IP of the newly created container
#       - errorMessage - error message of the operation that failed
####################################################
namespace: org.openscore.slang.docker.containers

imports:
 docker_images: org.openscore.slang.docker.images
 docker_containers: org.openscore.slang.docker.containers
flow:
  name: create_db_container
  inputs:
    - host
    - username
    - password
  workflow:
    pull_mysql_image:
      do:
        docker_images.pull_image:
          - imageName: "'mysql'"
          - host
          - username
          - password
      publish:
        - errorMessage

    create_mysql_container:
      do:
        docker_containers.create_container:
          - imageID: "'mysql'"
          - containerName: "'mysqldb'"
          - cmdParams: "'-e MYSQL_ROOT_PASSWORD=pass -e MYSQL_DATABASE=boot -e MYSQL_USER=user -e MYSQL_PASSWORD=pass'"
          - host
          - username
          - password
      publish:
        - errorMessage

    get_db_ip:
      do:
        docker_containers.get_container_ip:
          - containerName: "'mysqldb'"
          - host
          - username
          - password
      publish:
        - dbIp
        - errorMessage

  outputs:
    - dbIp
    - errorMessage

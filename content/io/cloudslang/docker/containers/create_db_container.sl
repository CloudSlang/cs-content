#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates a Docker DB container.
#
# Inputs:
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - path to private key file
#   - container_name - optional - name of the DB container - Default: mysqldb
#   - timeout - optional - time in milliseconds to wait for command to complete
# Outputs:
#   - db_IP - IP of newly created container
#   - error_message - error message of failed operation
####################################################
namespace: io.cloudslang.docker.containers

imports:
 docker_images: io.cloudslang.docker.images
 docker_containers: io.cloudslang.docker.containers
flow:
  name: create_db_container
  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - container_name:
        default: "'mysqldb'"
    - timeout:
        required: false
  workflow:
    - pull_mysql_image:
        do:
          docker_images.pull_image:
            - image_name: "'mysql'"
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - timeout:
                required: false
        publish:
          - error_message

    - create_mysql_container:
        do:
          docker_containers.run_container:
            - image_name: "'mysql'"
            - container_name
            - container_params: "'-e MYSQL_ROOT_PASSWORD=pass -e MYSQL_DATABASE=boot -e MYSQL_USER=user -e MYSQL_PASSWORD=pass'"
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
        publish:
          - error_message

    - get_db_ip:
        do:
          docker_containers.get_container_ip:
            - containerName: container_name
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - timeout:
                required: false
        publish:
          - container_ip
          - error_message

  outputs:
    - db_IP: "'' if 'container_ip' not in locals() else container_ip"
    - error_message

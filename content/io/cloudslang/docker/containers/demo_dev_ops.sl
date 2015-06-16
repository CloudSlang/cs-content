#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# Example of how to link Docker containers. Pulls a DB Docker image container and starts it.
# Then pulls a web application image container and starts it, linking it to the DB container.
# The application is then tested to see that it is up and running.
# If any of the steps fail, an error is sent notifying the error.
#
# Inputs:
#   - docker_host - Docker machine host
#   - docker_ssh_port - optional - SSH port - Default: 22
#   - docker_username - Docker machine username
#   - docker_password - optional - Docker machine password
#   - private_key_file - optional - path to private key file
#   - db_container_name - optional - name of the DB container - Default: mysqldb
#   - app_container_name - optional - name of the app container - Default: spring-boot-tomcat-mysql-app
#   - app_port - optional - web server port for the application - Default: 8080
#   - email_host - email host
#   - email_port - email port
#   - email_sender - email sender
#   - email_recipient - email recipient
#   - timeout - optional - time in milliseconds to wait for command to complete - Default: 30000000 ms (8.33 h)
# Results:
#   - SUCCESS
#   - FAILURE
####################################################
namespace: io.cloudslang.docker.containers

imports:
 docker_containers: io.cloudslang.docker.containers
 docker_images: io.cloudslang.docker.images
 base_mail: io.cloudslang.base.mail
 base_network: io.cloudslang.base.network

flow:
  name: demo_dev_ops
  inputs:
    - docker_host
    - docker_ssh_port:
        default: "'22'"
    - docker_username
    - docker_password:
        required: false
    - private_key_file:
        required: false
    - db_container_name:
        default: "'mysqldb'"
    - app_container_name:
        default: "'spring-boot-tomcat-mysql-app'"
    - app_port:
        default: "'8080'"
    - email_host
    - email_port
    - email_sender
    - email_recipient
    - timeout:
        default: "'30000000'"
  workflow:

    - create_db_container:
        do:
          docker_containers.create_db_container:
            - host: docker_host
            - port: docker_ssh_port
            - username: docker_username
            - password:
                default: docker_password
                required: false
            - private_key_file:
                required: false
            - container_name: db_container_name
            - timeout
        publish:
          - db_IP
          - error_message

    - pull_app_image:
        do:
          docker_images.pull_image:
            - image_name: "'meirwa/spring-boot-tomcat-mysql-app'"
            - host: docker_host
            - port: docker_ssh_port
            - username: docker_username
            - password:
                default: docker_password
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - timeout
        publish:
          - error_message

    - start_linked_container:
        do:
          docker_containers.start_linked_container:
            - dbContainerIp: db_IP
            - dbContainerName: db_container_name
            - imageName: "'meirwa/spring-boot-tomcat-mysql-app'"
            - containerName: app_container_name
            - linkParams: "dbContainerName + ':mysql'"
            - cmdParams: "'-e DB_URL=' + dbContainerIp + ' -p ' + app_port + ':8080'"
            - host: docker_host
            - port: docker_ssh_port
            - username: docker_username
            - password:
                default: docker_password
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - timeout
        publish:
          - container_ID
          - error_message

    - test_application:
        do:
          base_network.verify_app_is_up:
            - host: docker_host
            - port: app_port
            - attempts: 20
        publish:
          - error_message

    - on_failure:
        - send_error_mail:
            do:
              base_mail.send_mail:
                - hostname: email_host
                - port: email_port
                - from: email_sender
                - to: email_recipient
                - subject: "'Flow failure'"
                - body: "'Operation failed with the following error:<br>' + error_message"
            navigate:
              SUCCESS: FAILURE
              FAILURE: FAILURE

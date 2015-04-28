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
#   - docker_username - Docker machine username
#   - docker_password - Docker machine password
#   - email_host - email host
#   - email_port - email port
#   - email_sender - email sender
#   - email_recipient - email recipient
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
    - docker_username
    - docker_password
    - email_host
    - email_port
    - email_sender
    - email_recipient
  workflow:
    - create_db_container:
        do:
          docker_containers.create_db_container:
            - host: docker_host
            - username: docker_username
            - password: docker_password
        publish:
          - db_IP
          - error_message

    - pull_app_image:
        do:
          docker_images.pull_image:
            - imageName: "'meirwa/spring-boot-tomcat-mysql-app'"
            - host: docker_host
            - username: docker_username
            - password: docker_password
        publish:
          - error_message

    - start_linked_container:
        do:
          docker_containers.start_linked_container:
            - dbContainerIp: db_IP
            - dbContainerName: "'mysqldb'"
            - imageName: "'meirwa/spring-boot-tomcat-mysql-app'"
            - containerName: "'spring-boot-tomcat-mysql-app'"
            - linkParams: "dbContainerName + ':mysql'"
            - cmdParams: "'-e DB_URL=' + dbContainerIp + ' -p 8080:8080'"
            - host: docker_host
            - username: docker_username
            - password: docker_password
        publish:
          - container_ID
          - error_message

    - test_application:
        do:
          base_network.verify_app_is_up:
            - host: docker_host
            - port: "'8080'"
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

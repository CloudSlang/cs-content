#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#   This flow is an example of how to link Docker containers. It pulls a DB docker image container and starts it. Then it pulls
#   a web application image container and starts it, linking it to the DB container. The application is then tested that it is up and running.
#   If any of the steps fail, an error is send notifying the error.
#
#   Inputs:
#       - dockerHost - Linux machine IP
#       - dockerUsername - Username
#       - dockerPassword - Password
#       - emailHost - Email host
#       - emailPort - Email port
#       - emailSender - Email sender
#       - emailRecipient - Email recipient
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################
namespace: org.openscore.slang.docker.containers

imports:
 docker_containers: org.openscore.slang.docker.containers
 docker_images: org.openscore.slang.docker.images
 base_mail: org.openscore.slang.base.mail
 base_network: org.openscore.slang.base.network

flow:
  name: demo_dev_ops
  inputs:
    - dockerHost
    - dockerUsername
    - dockerPassword
    - emailHost
    - emailPort
    - emailSender
    - emailRecipient
  workflow:
    create_db_container:
      do:
        docker_containers.create_db_container:
          - host: dockerHost
          - username: dockerUsername
          - password: dockerPassword
      publish:
        - db_IP: dbIp
        - errorMessage

    pull_app_image:
      do:
        docker_images.pull_image:
          - imageName: "'meirwa/spring-boot-tomcat-mysql-app'"
          - host: dockerHost
          - username: dockerUsername
          - password: dockerPassword
      publish:
        - errorMessage

    start_linked_container:
      do:
        docker_containers.start_linked_container:
          - dbContainerIp: db_IP
          - dbContainerName: "'mysqldb'"
          - imageName: "'meirwa/spring-boot-tomcat-mysql-app'"
          - containerName: "'spring-boot-tomcat-mysql-app'"
          - linkParams: "dbContainerName + ':mysql'"
          - cmdParams: "'-e DB_URL=' + dbContainerIp + ' -p 8080:8080'"
          - host: dockerHost
          - username: dockerUsername
          - password: dockerPassword
      publish:
        - containerID
        - errorMessage

    test_application:
      do:
        base_network.verify_app_is_up:
          - host: dockerHost
          - port: "'8080'"
          - max_seconds_to_wait: 20
      publish:
        - errorMessage

    on_failure:
      send_error_mail:
        do:
          base_mail.send_mail:
            - hostname: emailHost
            - port: emailPort
            - from: emailSender
            - to: emailRecipient
            - subject: "'Flow failure'"
            - body: "'Operation failed with the following error:<br>' + errorMessage"
        navigate:
          SUCCESS: FAILURE
          FAILURE: FAILURE

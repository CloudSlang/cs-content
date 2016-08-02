#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Example of how to link Docker containers. Pulls a DB Docker image container and starts it.
#!               Then pulls a web application image container and starts it, linking it to the DB container.
#!               The application is then tested to see that it is up and running.
#!               If any of the steps fail, an error is sent notifying the error.
#! @input docker_host: Docker machine host
#! @input docker_ssh_port: optional - SSH port - Default: '22'
#! @input docker_username: Docker machine username
#! @input docker_password: optional - Docker machine password
#! @input private_key_file: optional - path to private key file
#! @input db_container_name: optional - name of the DB container - Default: 'mysqldb'
#! @input app_container_name: optional - name of the app container - Default: 'spring-boot-tomcat-mysql-app'
#! @input app_port: optional - web server port for the application - Default: '8080'
#! @input email_host: email host
#! @input email_port: email port
#! @input email_sender: email sender
#! @input email_recipient: email recipient
#! @input email_username: optional - email username
#! @input email_password: optional - email password
#! @input email_enable_TLS: optional - enable startTLS
#! @input timeout: optional - time in milliseconds to wait for command to complete - Default: 30000000 ms (8.33 h)
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#!!#
####################################################
namespace: io.cloudslang.docker.containers.examples

imports:
 containers: io.cloudslang.docker.containers
 images: io.cloudslang.docker.images
 mail: io.cloudslang.base.mail
 network: io.cloudslang.base.network

flow:
  name: demo_dev_ops
  inputs:
    - docker_host
    - docker_ssh_port: '22'
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - db_container_name: 'mysqldb'
    - app_container_name: 'spring-boot-tomcat-mysql-app'
    - app_port: '8080'
    - email_host
    - email_port
    - email_sender
    - email_recipient
    - email_username:
        required: false
    - email_password:
        required: false
        sensitive: true
    - email_enable_TLS:
        required: false
    - timeout: '30000000'
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:

    - create_db_container:
        do:
          containers.examples.create_db_container:
            - host: ${docker_host}
            - port: ${docker_ssh_port}
            - username: ${docker_username}
            - password: ${docker_password}
            - private_key_file
            - container_name: ${db_container_name}
            - timeout
        publish:
          - db_IP
          - error_message

    - pull_app_image:
        do:
          images.pull_image:
            - image_name: 'meirwa/spring-boot-tomcat-mysql-app'
            - host: ${docker_host}
            - port: ${docker_ssh_port}
            - username: ${docker_username}
            - password: ${docker_password}
            - privateKeyFile: ${private_key_file}
            - timeout
        publish:
          - error_message

    - start_linked_container:
        do:
          containers.start_linked_container:
            - image_name: 'meirwa/spring-boot-tomcat-mysql-app'
            - container_name: ${app_container_name}
            - link_params: "${db_container_name + ':mysql'}"
            - cmd_params: "${'-e DB_URL=' + db_IP + ' -p ' + app_port + ':8080'}"
            - host: ${docker_host}
            - port: ${docker_ssh_port}
            - username: ${docker_username}
            - password: ${docker_password}
            - private_key_file
            - timeout
        publish:
          - container_id
          - error_message

    - test_application:
        do:
          network.verify_url_is_accessible:
            - url: ${'http://' + docker_host + ':' + app_port}
            - attempts: 20
            - time_to_sleep: 10
            - proxy_host
            - proxy_port
        publish:
          - error_message: ${output_message}

    - on_failure:
        - send_error_mail:
            do:
              mail.send_mail:
                - hostname: ${email_host}
                - port: ${email_port}
                - from: ${email_sender}
                - to: ${email_recipient}
                - subject: 'Flow failure'
                - body: "${'Operation failed with the following error:<br>' + error_message}"
                - username: ${email_username}
                - password: ${email_password}
                - enable_TLS: ${email_enable_TLS}

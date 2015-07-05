#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.docker.containers

imports:
  docker_containers_examples: io.cloudslang.docker.containers.examples
  containers: io.cloudslang.docker.containers
  images: io.cloudslang.docker.images
  maintenance: io.cloudslang.docker.maintenance
  strings: io.cloudslang.base.strings

flow:
  name: test_demo_clear_containers_wrapper
  inputs:
    - host
    - port:
        required: false
    - username
    - password

  workflow:
    - pre_test_cleanup:
         do:
           maintenance.clear_docker_host:
             - docker_host: host
             - port:
                 required: false
             - docker_username: username
             - docker_password: password
         navigate:
           SUCCESS: start_mysql_container
           FAILURE: MACHINE_IS_NOT_CLEAN

    - start_mysql_container:
        do:
          docker_containers_examples.create_db_container:
            - host
            - port:
                required: false
            - username
            - password
        publish:
          - db_IP
        navigate:
          SUCCESS: pull_linked_image
          FAILURE: FAIL_TO_START_MYSQL_CONTAINER

    - pull_linked_image:
        do:
          images.pull_image:
            - image_name: "'meirwa/spring-boot-tomcat-mysql-app'"
            - host
            - port:
                required: false
            - username
            - password
        navigate:
          SUCCESS: start_linked_container
          FAILURE: FAIL_TO_PULL_LINKED_CONTAINER

    - start_linked_container:
        do:
          containers.start_linked_container:
            - dbContainerIp: db_IP
            - dbContainerName: "'mysqldb'"
            - imageName: "'meirwa/spring-boot-tomcat-mysql-app'"
            - containerName: "'spring-boot-tomcat-mysql-app'"
            - linkParams: "dbContainerName + ':mysql'"
            - cmdParams: "'-e DB_URL=' + dbContainerIp + ' -p ' + '8080' + ':8080'"
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - timeout:
                default: "'30000000'"
        publish:
          - container_ID
          - error_message

    - demo_clear_containers_wrapper:
        do:
          docker_containers_examples.demo_clear_containers_wrapper:
            - db_container_ID: "'mysqldb'"
            - linked_container_ID: "'spring-boot-tomcat-mysql-app'"
            - docker_host: host
            - port:
                required: false
            - docker_username: username
            - docker_password: password
        navigate:
          SUCCESS: verify
          FAILURE: FAILURE

    - verify:
        do:
          containers.get_all_containers:
            - host
            - port:
                required: false
            - username
            - password
            - all_containers: true
        publish:
          - all_containers: container_list
    - compare:
        do:
          strings.string_equals:
            - first_string: all_containers
            - second_string: "''"
        navigate:
          SUCCESS: clear_docker_host
          FAILURE: FAILURE

    - clear_docker_host:
        do:
         maintenance.clear_docker_host:
           - docker_host: host
           - port:
               required: false
           - docker_username: username
           - docker_password: password
        navigate:
         SUCCESS: SUCCESS
         FAILURE: MACHINE_IS_NOT_CLEAN

  results:
    - SUCCESS
    - FAILURE
    - MACHINE_IS_NOT_CLEAN
    - FAIL_TO_START_MYSQL_CONTAINER
    - FAIL_TO_PULL_LINKED_CONTAINER
#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   This flow retrieves cAdviser status and perform restart to the container is the resourses useges is high
#
#   Inputs:
#       - container - name or ID of the Docker container that runs MySQL
#       - Host - Docker machine host
#       - cadvisor_port - optional - port used for cAdvisor - Default: 8080
#       - username - Docker machine username
#       - password - Docker machine password
#       - machine_connect_port- port to use to connect the machine runs rhe docker
#       - privateKeyFile - the absolute path to the private key file; Default: none
#       - rule - optional - python query to determine if the resource usages is high
#   Results:
#       - SUCCESS - parsing was successful (returnCode == '0')
#       - FAILURE - otherwise
##################################################################################################################################################

namespace: org.openscore.slang.docker.cadvisor

imports:
  docker_cadvisor: org.openscore.slang.docker.cadvisor
  docker_container: org.openscore.slang.docker.containers
  docker_print: org.openscore.slang.base.print

flow:
  name: restart_container_base_on_usage
  inputs:
    - container
    - host
    - cadvisor_port:
        default: "'8080'"
        required: false
    - machine_connect_port:
        default: "'22'"
        required: false
    - username
    - password
    - privateKeyFile:
        default: "''"
    - rule:
        default: "''"
        required: false
  workflow:
    retrieve_container_usage_cAdvisor:
          do:
            docker_cadvisor.report_container_metrics_cAdvisor:
                - container
                - host
                - cadvisor_port
          publish:
            - memory_usage
            - cpu_usage
            - throughput_rx
            - throughput_tx
            - error_rx
            - error_tx
            - returnCode
            - errorMessage
    evaluate_resource_usage:
      do:
        docker_cadvisor.evaluate_resource_usage:
          - rule
          - memory_usage
          - cpu_usage
          - throughput_rx
          - throughput_tx
          - error_rx
          - error_tx
          - errorMessage
      navigate:
          MORE: stop_container
          LESS: SUCCESS
          FAILURE: FAILURE
    stop_container:
      do:
        docker_container.stop_container:
           - containerID: container
           - host
           - username
           - password
           - port: machine_connect_port
           - privateKeyFile
      publish:
        - errorMessage
      navigate:
          SUCCESS: start_container
          FAILURE: FAILURE
    start_container:
      do:
        docker_container.start_container:
           - privateKeyFile
           - containerID: container
           - host
           - username
           - password
           - port: machine_connect_port
      publish:
        - errorMessage
    on_failure:
      print_error:
        do:
          docker_print.print_text:
                - text: "'cAdviser ended with the following error message '+errorMessage"
        navigate:
          SUCCESS: FAILURE
          FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
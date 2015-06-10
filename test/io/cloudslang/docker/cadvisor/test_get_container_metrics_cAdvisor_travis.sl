#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.docker.cadvisor

imports:
  cadvisor: io.cloudslang.docker.cadvisor
  print: io.cloudslang.base.print

flow:
  name: test_get_container_metrics_cAdvisor_travis

  inputs:
    - host
    - cadvisor_port:
        required: false
    - container

  workflow:

    - get_container_metrics_cAdvisor:
        do:
          cadvisor.get_container_metrics_cAdvisor:
            - host
            - cadvisor_port:
                required: false
            - container
        publish:
          - return_result: returnResult
        navigate:
          SUCCESS: SUCCESS
          FAILURE: print_message

    - print_message:
        do:
          print.print_text:
            - text: >
                'Message: ' + return_result
        navigate:
          SUCCESS: FAILURE

  results:
    - SUCCESS
    - FAILURE

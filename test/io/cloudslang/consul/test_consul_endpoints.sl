#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.consul

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  base_utils: io.cloudslang.base.utils

flow:
  name: test_consul_endpoints
  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - node
    - address
    - service

  workflow:

    - register_endpoint:
        do:
          register_endpoint:
            - host
            - node
            - address
            - service
        navigate:
          SUCCESS: get_catalog_services
          FAILURE: FAIL_TO_REGISTER

    - get_catalog_services:
        do:
          get_catalog_services:
            - host
            - node
            - address
            - service
        navigate:
          SUCCESS: deregister_endpoint
          FAILURE: FAIL_TO_GET_SERVICES
        publish:
          - services_after_register: returnResult
          - errorMessage

    - deregister_endpoint:
        do:
          deregister_endpoint:
            - host
            - node
        navigate:
          SUCCESS: get_catalog_services2
          FAILURE: FAIL_TO_DEREGISTER

    - get_catalog_services2:
        do:
          get_catalog_services:
            - host
            - node
            - address
            - service
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAIL_TO_GET_SERVICES
        publish:
          - services_after_deregister: returnResult
          - errorMessage
  outputs:
    - services_after_register: str(services_after_register)
    - services_after_deregister: str(services_after_deregister)
  results:
    - SUCCESS
    - FAIL_TO_REGISTER
    - FAIL_TO_DEREGISTER
    - FAIL_TO_GET_SERVICES

#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################

namespace: io.cloudslang.amazon.aws.ec2.instances

imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
  lists: io.cloudslang.base.lists

flow:
  name: test_update_instance_type

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        default: ''
        required: false
    - credential:
        default: ''
        required: false
    - proxy_host:
        default: ''
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - debug_mode:
        default: 'false'
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - instance_id
    - server_type:
        default: ''
        required: false
    - operation_timeout:
        default: ''
        required: false
    - pooling_interval:
        default: ''
        required: false

  workflow:
    - update_instance_type:
        do:
          instances.update_instance_type:
            - provider
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - debug_mode
            - region
            - instance_id
            - server_type
            - operation_timeout
            - pooling_interval
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_results
          - FAILURE: UPDATE_SERVER_TYPE_FAILURE

    - check_results:
        do:
          lists.compare_lists:
            - list_1: ${str(return_result) + "," + str(exception) + "," + return_code}
            - list_2: "Server updated successfully.,,0"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULTS_FAILURE

  results:
    - SUCCESS
    - UPDATE_SERVER_TYPE_FAILURE
    - CHECK_RESULTS_FAILURE

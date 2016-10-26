#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.amazon.ec2.samples

imports:
  samples: io.cloudslang.amazon.ec2.samples
  lists: io.cloudslang.base.lists

flow:
  name: test_ec2_classic_undeploy

  inputs:
    - provider: ${get_sp('io.cloudslang.amazon.ec2.provider')}
    - endpoint: ${get_sp('io.cloudslang.amazon.ec2.endpoint')}
    - identity
    - credential:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - debug_mode:
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - instance_id

  workflow:
      - ec2_classic_undeploy:
          do:
            samples.ec2_classic_undeploy:
              - provider
              - endpoint
              - identity
              - credential
              - proxy_host
              - proxy_port
              - debug_mode
              - region
              - instance_id
          publish:
            - return_result
            - return_code
            - exception: ${'' if exception == None else exception}
          navigate:
            - SUCCESS: check_ec2_classic_undeploy_result
            - TERMINATE_INSTANCE_FAILURE: TERMINATE_INSTANCE_FAILURE
            - CHECK_TERMINATE_INSTANCE_FAILURE: CHECK_TERMINATE_INSTANCE_FAILURE
            - SHUTTING_DOWN_FAILURE: SHUTTING_DOWN_FAILURE

      - check_ec2_classic_undeploy_result:
          do:
            lists.compare_lists:
              - list_1: ${str(exception) + "," + return_code}
              - list_2: ${get_sp('io.cloudslang.amazon.ec2.success_call_list')}
          navigate:
            - SUCCESS: SUCCESS
            - FAILURE: CHECK_EC2_CLASSIC_UNDEPLOY_FAILURE

  outputs:
    - return_result
    - return_code
    - exception

  results:
    - SUCCESS
    - TERMINATE_INSTANCE_FAILURE
    - CHECK_TERMINATE_INSTANCE_FAILURE
    - SHUTTING_DOWN_FAILURE
    - CHECK_EC2_CLASSIC_UNDEPLOY_FAILURE
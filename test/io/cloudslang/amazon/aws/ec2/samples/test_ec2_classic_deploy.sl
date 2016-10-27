#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.amazon.aws.ec2.samples

imports:
  samples: io.cloudslang.amazon.aws.ec2.samples
  lists: io.cloudslang.base.lists

flow:
  name: test_ec2_classic_deploy

  inputs:
    - provider: ${get_sp('io.cloudslang.amazon.aws.ec2.provider')}
    - endpoint: ${get_sp('io.cloudslang.amazon.aws.ec2.endpoint')}
    - identity
    - credential:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - availability_zone:
        default: ''
        required: false
    - image_id
    - debug_mode:
        required: false
    - instance_name
    - platform:
        default: ''
        required: false

  workflow:
      - ec2_classic_deploy:
          do:
            samples.ec2_classic_deploy:
              - provider
              - endpoint
              - identity
              - credential
              - proxy_host
              - proxy_port
              - region
              - availability_zone
              - image_id
              - debug_mode
              - instance_name
              - platform
          publish:
            - instance_id
            - return_result
            - return_code
            - exception: ${'' if exception == None else exception}
          navigate:
            - SUCCESS: check_ec2_classic_deploy_result
            - LAUNCH_INSTANCE_FAILURE: LAUNCH_INSTANCE_FAILURE
            - CHECK_LAUNCH_INSTANCE_FAILURE: CHECK_LAUNCH_INSTANCE_FAILURE
            - EXTRACT_INSTANCE_ID_STRING_FAILURE: EXTRACT_INSTANCE_ID_STRING_FAILURE
            - EXTRACT_INSTANCE_ID_FAILURE: EXTRACT_INSTANCE_ID_FAILURE
            - SLEEP_UNTIL_INSTANCE_AVAILABLE_FAIL: SLEEP_UNTIL_INSTANCE_AVAILABLE_FAIL
            - TAG_INSTANCE_FAILURE: TAG_INSTANCE_FAILURE
            - GET_INSTANCE_DETAILS_FAILURE: GET_INSTANCE_DETAILS_FAILURE

      - check_ec2_classic_deploy_result:
          do:
            lists.compare_lists:
              - list_1: ${str(exception) + "," + return_code}
              - list_2: ${get_sp('io.cloudslang.amazon.aws.ec2.success_call_list')}
          navigate:
            - SUCCESS: SUCCESS
            - FAILURE: CHECK_EC2_CLASSIC_DEPLOY_FAILURE

  outputs:
    - instance_id
    - return_result
    - return_code
    - exception

  results:
    - SUCCESS
    - LAUNCH_INSTANCE_FAILURE
    - CHECK_LAUNCH_INSTANCE_FAILURE
    - EXTRACT_INSTANCE_ID_STRING_FAILURE
    - EXTRACT_INSTANCE_ID_FAILURE
    - SLEEP_UNTIL_INSTANCE_AVAILABLE_FAIL
    - TAG_INSTANCE_FAILURE
    - GET_INSTANCE_DETAILS_FAILURE
    - CHECK_EC2_CLASSIC_DEPLOY_FAILURE
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
namespace: io.cloudslang.cloud.amazon_aws.volumes

imports:
  volumes: io.cloudslang.cloud.amazon_aws.volumes
  lists: io.cloudslang.base.lists

flow:
  name: test_create_volume

  inputs:
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
        default: ''
        required: false
    - proxy_username:
        default: ''
        required: false
    - proxy_password:
        default: ''
        required: false
    - availability_zone
    - encrypted:
        default: ''
        required: false
    - iops:
        default: ''
        required: false
    - kms_key_id:
        default: ''
        required: false
    - size:
        default: ''
        required: false
    - snapshot_id:
        default: ''
        required: false
    - volume_type:
        default: ''
        required: false
    - version

  workflow:
    - create_volume:
        do:
          volumes.create_volume:
            - provider
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - availability_zone
            - encrypted
            - iops
            - kms_key_id
            - size
            - snapshot_id
            - volume_type
            - version
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_result
          - FAILURE: CREATE_VOLUME_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${[str(exception), int(return_code)]}
            - list_2: ['', 0]
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULT_FAILURE

  results:
    - SUCCESS
    - CREATE_VOLUME_FAILURE
    - CHECK_RESULT_FAILURE
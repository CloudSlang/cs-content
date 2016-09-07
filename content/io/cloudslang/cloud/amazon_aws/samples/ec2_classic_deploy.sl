#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Deploys an Amazon Web Services Elastic Compute Cloud (EC2 Classic) instance
#!               Note: The instance will be launched into a specified region or if the region is not specified then
#!                     'us-east-1' region (default) will be used. The instance will use a specific AMI and will be tagged.
#!                     The instance will be attached to an existing default network then the instance will be started.
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: "AKIAIOSFODNN7EXAMPLE"
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
#! @input proxy_host: optional - proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: optional - proxy server port. You must either specify values for both <proxyHost> and <proxyPort>
#!                    inputs or leave them both empty.
#! @input proxy_username: optional - proxy server user name.
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value.
#! @input region: optional - region where the server (instance) to be created/launched can be found. "regions/list_regions"
#!                operation can be used in order to get all regions.
#!                Default: 'us-east-1'
#! @input availability_zone: optional - specifies the placement constraints for launching instance. If not provided Amazon
#!                           will automatically select an availability zone by default. For more information go to:
#!                           http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
#!                           Example: 'us-east-1d'
#!                           Default: ''
#! @input image_id: ID of the AMI needed to launch instance out of it. For more information go to:
#!                  http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html
#!                  Example: 'ami-abcdef12'
#! @input debug_mode: optional - if 'true' then the execution logs will be shown in CLI console.
#!                    Default: 'false'
#! @input instance_name: Name for newly created instance.
#! @input platform: optional - Platform. Use 'windows' if you have Windows instances; otherwise, leave blank.
#!                  Valid values: '', 'windows'
#!                  Default: ''
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the server (instance) was successfully launched/created
#! @result FAILURE: an error occurred when trying to launch/create a server (instance)
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.samples

imports:
  instances: io.cloudslang.cloud.amazon_aws.instances
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings
  tags: io.cloudslang.cloud.amazon_aws.tags
  utils: io.cloudslang.base.flow_control

flow:
  name: ec2_classic_deploy

  inputs:
    - provider: ${get_sp('io.cloudslang.cloud.amazon_aws.provider')}
    - endpoint: ${get_sp('io.cloudslang.cloud.amazon_aws.endpoint')}
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
      - launch_instance:
          do:
            instances.run_instances:
              - provider
              - endpoint
              - identity
              - credential
              - proxy_host
              - proxy_port
              - debug_mode
              - region
              - availability_zone
              - image_id
              - min_count: '1'
              - max_count: '1'
          publish:
            - return_result
            - return_code
            - exception: ${'' if exception == None else exception}
          navigate:
            - SUCCESS: check_launch_instance_result
            - FAILURE: LAUNCH_INSTANCE_FAILURE

      - check_launch_instance_result:
          do:
            lists.compare_lists:
              - list_1: ${str(exception) + "," + return_code}
              - list_2: ${get_sp('io.cloudslang.cloud.amazon_aws.success_call_list')}
          navigate:
            - SUCCESS: extract_instance_id_string
            - FAILURE: CHECK_LAUNCH_INSTANCE_FAILURE

      - extract_instance_id_string:
          do:
            strings.match_regex:
              - regex: ${get_sp('io.cloudslang.cloud.amazon_aws.instance_output_id_regex')}
              - text: ${return_result}
          publish:
            - instance_id_string: ${match_text}
          navigate:
            - MATCH: get_instance_id_string_length
            - NO_MATCH: EXTRACT_INSTANCE_ID_STRING_FAILURE

      - get_instance_id_string_length:
          do:
            strings.length:
              - origin_string: ${instance_id_string}
          publish:
            - instance_id_string_length: ${length}
          navigate:
            - SUCCESS: get_instance_id

      - get_instance_id:
          do:
            strings.substring:
              - origin_string: ${instance_id_string}
              - begin_index: '3'
              - end_index: ${instance_id_string_length}
          publish:
            - instance_id: ${new_string}
            - exception: ${'' if error_message == None else error_message}
          navigate:
            - SUCCESS: sleep_until_instance_available
            - FAILURE: EXTRACT_INSTANCE_ID_FAILURE

      - sleep_until_instance_available:
          do:
            utils.sleep:
              - seconds: ${get_sp('io.cloudslang.cloud.amazon_aws.aws_latency')}
          navigate:
            - SUCCESS: tag_instance
            - FAILURE: SLEEP_UNTIL_INSTANCE_AVAILABLE_FAIL

      - tag_instance:
          do:
            tags.apply_to_resources:
              - provider
              - endpoint
              - identity
              - credential
              - proxy_host
              - proxy_port
              - delimiter
              - debug_mode
              - region
              - key_tags_string: 'Name'
              - value_tags_string: ${instance_name}
              - resource_ids_string: ${instance_id}
          publish:
            - return_result
            - return_code
            - exception: ${'' if exception == None else exception}
          navigate:
            - SUCCESS: get_instance_details
            - FAILURE: TAG_INSTANCE_FAILURE

      - get_instance_details:
          do:
            instances.describe_instances:
              - provider
              - endpoint
              - identity
              - credential
              - proxy_host
              - proxy_port
              - delimiter
              - debug_mode
              - region
              - image_id
              - instance_id
              - platform
          publish:
            - return_result
            - return_code
            - exception: ${'' if exception == None else exception}
          navigate:
            - SUCCESS: SUCCESS
            - FAILURE: GET_INSTANCE_DETAILS_FAILURE

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
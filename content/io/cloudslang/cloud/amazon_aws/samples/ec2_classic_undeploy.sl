#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Un-deploys/terminates an Amazon Web Services Elastic Compute Cloud (EC2 Classic) instance
#!               Note: As with all Amazon EC2 operations, the results might not appear immediately. Terminated instances
#!                     remain visible after termination for approximately one hour
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: "AKIAIOSFODNN7EXAMPLE"
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
#! @input proxy_host: optional - proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: optional - proxy server port. You must either specify values for both <proxyHost> and <proxyPort>
#!                    inputs or leave them both empty.
#! @input debug_mode: optional - if 'true' then the execution logs will be shown in CLI console.
#!                    Default: 'false'
#! @input region: optional - region where the server (instance) to be created/launched can be found. "regions/list_regions"
#!                operation can be used in order to get all regions.
#!                Default: 'us-east-1'
#! @input instance_id: the ID of the server (instance) you want to terminate
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the instance was successfully un-deployed/terminated
#! @result FAILURE: an error occurred when trying to launch/create a server (instance)
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.samples

imports:
  instances: io.cloudslang.cloud.amazon_aws.instances
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: ec2_classic_undeploy

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
    - debug_mode:
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - instance_id

  workflow:
      - terminate_instance:
          do:
            instances.terminate_instances:
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
            - SUCCESS: check_terminate_instance_result
            - FAILURE: TERMINATE_INSTANCE_FAILURE

      - check_terminate_instance_result:
          do:
            lists.compare_lists:
              - list_1: ${str(exception) + "," + return_code}
              - list_2: ${get_sp('io.cloudslang.cloud.amazon_aws.success_call_list')}
          navigate:
            - SUCCESS: check_first_possible_current_state_result
            - FAILURE: CHECK_TERMINATE_INSTANCE_FAILURE

      - check_first_possible_current_state_result:
          do:
            strings.string_occurrence_counter:
              - string_in_which_to_search: ${return_result}
              - string_to_find: 'currentState=terminated'
          navigate:
            - SUCCESS: SUCCESS
            - FAILURE: check_second_possible_current_state_result

      - check_second_possible_current_state_result:
          do:
            strings.string_occurrence_counter:
              - string_in_which_to_search: ${return_result}
              - string_to_find: 'currentState=shutting-down'
          navigate:
            - SUCCESS: SUCCESS
            - FAILURE: SHUTTING_DOWN_FAILURE

  outputs:
    - return_result
    - return_code
    - exception

  results:
    - SUCCESS
    - TERMINATE_INSTANCE_FAILURE
    - CHECK_TERMINATE_INSTANCE_FAILURE
    - SHUTTING_DOWN_FAILURE
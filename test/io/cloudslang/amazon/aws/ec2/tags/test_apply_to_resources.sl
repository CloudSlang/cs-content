#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################

namespace: io.cloudslang.amazon.aws.ec2.tags

imports:
  tags: io.cloudslang.amazon.aws.ec2.tags
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_apply_to_resources

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
    - delimiter:
        default: ','
        required: false
    - debug_mode:
        default: 'false'
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - key_tags_string
    - value_tags_string
    - resource_ids_string

  workflow:
    - apply_tag_to_resources:
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
            - key_tags_string
            - value_tags_string
            - resource_ids_string
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_result
          - FAILURE: APPLY_TO_RESOURCES_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(exception) + "," + return_code}
            - list_2: ",0"
        navigate:
          - SUCCESS: check_apply_tag_message_exist
          - FAILURE: CHECK_RESULT_FAILURE

    - check_apply_tag_message_exist:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: 'Apply tags to resources process started successfully.'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_APPLY_TO_RESOURCES_MESSAGE_FAILURE

  results:
    - SUCCESS
    - APPLY_TO_RESOURCES_FAILURE
    - CHECK_RESULT_FAILURE
    - CHECK_APPLY_TO_RESOURCES_MESSAGE_FAILURE

#   (c) Copyright 2015 Tusa Mihai
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs Amazon Web Services Elastic Compute Cloud (EC2) commands to verify if the targeted server (instance) is running.
#
#    Inputs:
#      - provider - the cloud provider on which the instance is - Default: "'amazon'"
#      - endpoint - the endpoint to which first request will be sent - Default: "'https://ec2.amazonaws.com'"
#      - identity - optional - the username of your account or the Amazon Access Key ID
#      - credential - optional - the password of the user or the Amazon Secret Access Key that correspond to the identity input
#      - region - optional - the region where the server (instance) to be started can be found. list_regions operation can be used in order to get all regions  - Default: "'us-east-1'"
#      - serverId - optional - the ID of the server (instance) you want to start
#      - proxyHost - optional - the proxy server used to access the provider services
#      - proxyPort - optional - the proxy server port used to access the provider services
#      - delimiter - optional - the delimiter used to separate the list of servers
#      - seconds - optional - time to wait (seconds) until the check server (instance) state is made - Default: 45
#
# Results:
#  SUCCESS: the server (instance) was successfully started
#  START_FAILURE: the start_server operation fails
#  LIST_FAILURE: the list_server operation fails
#  RUNNING_FAILURE: the server (instance) is not running
#
####################################################
namespace: io.cloudslang.cloud_provider.amazon_aws

imports:
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: test_start_server
  inputs:
    - provider: "'amazon'"
    - endpoint: "'https://ec2.amazonaws.com'"
    - identity:
        required: false
    - credential:
        required: false
    - region:
        default: "'us-east-1'"
        required: false
    - serverId:
        required: false
    - proxyHost:
        required: false
    - proxyPort:
        required: false
    - delimiter:
        required: false
    - seconds:
        default: '45'
        required: false

  workflow:
    - start_server:
        do:
          start_server:
            - provider
            - endpoint
            - identity
            - credential
            - region
            - serverId
            - proxyHost
            - proxyPort
        navigate:
          SUCCESS: sleep
          FAILURE: START_FAILURE

    - sleep:
        do:
          utils.sleep:
            - seconds
        navigate:
          SUCCESS: list_amazon_instances

    - list_amazon_instances:
        do:
          list_servers:
            - provider
            - endpoint
            - identity
            - credential
            - region
            - proxyHost
            - proxyPort
            - delimiter
        navigate:
          SUCCESS: check_result
          FAILURE: LIST_FAILURE
        publish:
          - return_result
          - return_code
          - exception

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: return_result
            - string_to_find: "serverId + ', state=running'"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: RUNNING_FAILURE

  results:
    - SUCCESS
    - START_FAILURE
    - LIST_FAILURE
    - RUNNING_FAILURE
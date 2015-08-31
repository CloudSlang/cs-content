#   (c) Copyright 2015 Tusa Mihai
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs an Amazon Web Services Elastic Compute Cloud (EC2) command to list the servers (instances) from a cloud region.
#
#    Inputs:
#      - provider - the cloud provider on which the instance is - Default: "'amazon'"
#      - endpoint - the endpoint to which first request will be sent - Default: "'https://ec2.amazonaws.com'"
#      - identity - optional - the username of your account or the Amazon Access Key ID
#      - credential - optional - the password of the user or the Amazon Secret Access Key that correspond to the identity input
#      - region - optional - the region where the servers (instances) are. list_regions operation can be used in order to get all regions  - Default: "'us-east-1'"
#      - proxyHost - optional - the proxy server used to access the provider services
#      - proxyPort - optional - the proxy server port used to access the provider services
#      - delimiter - optional - the delimiter used in result list
#
# Results:
#  SUCCESS: the server (instance) was successfully started
#  FAILURE: an error when trying to start a server (instance)
#
####################################################
namespace: io.cloudslang.cloud_provider.amazon_aws

operation:
  name: list_servers

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
    - proxyHost:
        required: false
    - proxyPort:
        required: false
    - delimiter:
        required: false
  action:
    java_action:
      className: io.cloudslang.content.jclouds.actions.ListServersAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - return_code: returnCode
    - exception: "'' if 'exception' not in locals() else exception"
  results:
    - SUCCESS: returnCode == '0'
    - FAILURE
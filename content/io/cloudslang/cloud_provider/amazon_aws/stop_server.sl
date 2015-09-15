#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs an Amazon Web Services Elastic Compute Cloud (EC2) command to stop an ACTIVE server (instance) and changes its status to STOPPED.
# SUSPENDED servers (instances) cannot be stopped.
#
#    Inputs:
#      - provider - the cloud provider on which the instance is - Default: "'amazon'"
#      - endpoint - the endpoint to which first request will be sent - Default: "'https://ec2.amazonaws.com'"
#      - identity - optional - the username of your account or the Amazon Access Key ID
#      - credential - optional - the password of the user or the Amazon Secret Access Key that correspond to the identity input
#      - region - optional - the region where the server (instance) to be stopped can be found. list_regions operation can be used in order to get all regions  - Default: "'us-east-1'"
#      - serverId - optional - the ID of the server (instance) you want to stop
#      - proxyHost - optional - the proxy server used to access the provider services
#      - proxyPort - optional - the proxy server port used to access the provider services
#
# Results:
#  SUCCESS: the server (instance) was successfully stopped
#  FAILURE: an error when trying to stop a server (instance)
#
####################################################
namespace: io.cloudslang.cloud_provider.amazon_aws

operation:
  name: stop_server

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
  action:
    java_action:
      className: io.cloudslang.content.jclouds.actions.StopServerAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - return_code: returnCode
    - exception: "'' if 'exception' not in locals() else exception"
  results:
    - SUCCESS: returnCode == '0'
    - FAILURE
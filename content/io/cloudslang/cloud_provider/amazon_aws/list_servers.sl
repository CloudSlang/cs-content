#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to list the servers (instances)
#   from a cloud region.
#
# Inputs:
#   - provider - the cloud provider on which the instance is - Default: 'amazon'
#   - endpoint - the endpoint to which first request will be sent - Default: 'https://ec2.amazonaws.com'
#   - identity - optional - the Amazon Access Key ID
#   - credential - optional - the Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#   - region - optional - the region where the servers (instances) are. list_regions operation can be used in order
#                         to get all regions - Default: 'us-east-1'
#   - proxy_host - optional - the proxy server used to access the provider services
#   - proxy_port - optional - the proxy server port used to access the provider services - Default: '8080'
#   - delimiter - optional - the delimiter used in result list
# Outputs:
#   - return_result - contains the exception in case of failure, success message otherwise
#   - return_code - "0" if inserting was successful, "-1" otherwise
#   - error_message - error message if there was an error when executing, empty otherwise
# Results:
#  SUCCESS: the server (instance) was successfully started
#  FAILURE: an error when trying to start a server (instance)
####################################################
namespace: io.cloudslang.cloud_provider.amazon_aws

operation:
  name: list_servers

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        required: false
    - credential:
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        overridable: false
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        overridable: false
    - delimiter:
        required: false
  action:
    java_action:
      className: io.cloudslang.content.jclouds.actions.ListServersAction
      methodName: execute
  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${'' if 'exception' not in locals() else exception}
  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

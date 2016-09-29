#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#!
#!
#!!#
####################################################

namespace: io.cloudslang.cloud.azure

operation:
  name: get_authorization_token

  inputs:
    - identifier:
        required: true
    - primary_or_secondary_key:
        required: true
    - primaryOrSecondaryKey:
        default: ${get("primary_or_secondary_key", "")}
        private: true
    - availability_time:
        required: true
    - availabilityTime:
        required: true
        private: true
        default: ${get("availability_time", "")}

  java_action:
    gav: 'io.cloudslang.content:cs-azure:0.0.1'
    class_name: io.cloudslang.content.azure.actions.GetAuthorizationToken
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - exception: ${exception}
  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
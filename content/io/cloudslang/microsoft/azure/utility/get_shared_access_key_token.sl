#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Generates the authorization token for external Azure API calls.
#! @input identifier: the Identifier text box in the Credentials section of the Service Management API tab of System Settings
#! @input primary_or_secondary_key: the Primary Key or the Secondary Key in the Credentials section of the Service
#!                                  Management API tab of System Settings
#! @input expiry: the expiration date and time for the access token, the value must be in the format MM/DD/YYYY H:MM PM|AM
#!               Example: 08/04/2014 10:03 PM
#! @output return_result: the shared access authorization token for Azure
#! @output exception: the error message of the operation, if any
#! @output return_code: '0' if success, '-1' otherwise
#! @result SUCCESS: operation succeeded and returned the value for the authorization header
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.microsoft.azure.utility

operation:
  name: get_shared_access_key_token

  inputs:
    - identifier
    - primary_or_secondary_key
    - primaryOrSecondaryKey:
        default: ${get("primary_or_secondary_key", "")}
        required: false
        private: true
    - expiry

  java_action:
    gav: 'io.cloudslang.content:cs-azure:0.0.2'
    class_name: io.cloudslang.content.azure.actions.GetSharedAccessKeyToken
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception
  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

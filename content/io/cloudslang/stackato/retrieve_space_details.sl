#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves an unparsed OpenStack authentication token and tenantID.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - username - OpenStack username
#   - password - OpenStack password
#   - tenant_name - name of the project on OpenStack
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 200
#   - return_code - if returnCode == -1 then there was an error
#   - error_message: returnResult if returnCode == -1 or statusCode != 200
# Results:
#   - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.stackato

operation:
  name: retrieve_space_details
  inputs:
    - host
    - token
    - guid
    - url:
        default: "'https://' + host + '/v2/spaces/' + guid"
        overridable: false
    - headers:
        default: "'Authorization: bearer ' + token"
        overridable: false
    - trustAllRoots:
        default: "'true'"
    - method:
        default: "'get'"
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - status_code: "'' if 'statusCode' not in locals() else statusCode"
    - return_code: returnCode
    - error_message: returnResult if returnCode == '-1' or statusCode != 200 else ''
  results:
    - SUCCESS: "'statusCode' in locals() and returnCode != '-1' and statusCode == '200'"
    - FAILURE
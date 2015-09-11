#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Executes a GET REST call.
#
# Inputs:
#   - url - URL to which the call is made
#   - username - optional - username used for URL authentication; for NTLM authentication, the required format is 'domain\user'
#   - password - optional - password used for URL authentication
#   - proxyHost - optional - proxy server used to access the web site
#   - proxyPort - optional - proxy server port - Default: 8080
#   - proxyUsername - optional - user name used when connecting to the proxy
#   - proxyPassword - optional - proxy server password associated with the <proxyUsername> input value
#   - connectTimeout - optional - time to wait for a connection to be established, in seconds - Default: 0
#   - socketTimeout - optional - time to wait for data to be retrieved, in milliseconds - Default: 0
#   - headers - optional - list containing the headers to use for the request separated by new line (CRLF); header name - value pair will be separated by ":" - Format: According to HTTP standard for headers (RFC 2616) - Examples: Accept:text/plain
#   - queryParams - optional - list containing query parameters to append to the URL - Examples: parameterName1=parameterValue1&parameterName2=parameterValue2;
#   - contentType - optional - content type that should be set in the request header, representing the MIME-type of the data in the message body - Default: text/plain
# Outputs:
#   - return_result - response of the operation
#   - error_message - returnResult if statusCode different than '200'
#   - return_code - 0 if success, -1 otherwise
# Results:
#   - SUCCESS - operation succeeded (statusCode == '200')
#   - FAILURE - otherwise
################################################

namespace: io.cloudslang.base.network.rest

flow:
  name: http_client_get
  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
    - proxyHost:
        required: false
    - proxyPort: "'8080'"
    - proxyUsername:
        required: false
    - proxyPassword:
        required: false
    - connectTimeout: "'0'"
    - socketTimeout: "'0'"
    - headers:
        required: false
    - queryParams:
        required: false
    - contentType: "'text/plain'"
  workflow:
    - http_client_action_get:
        do:
          http_client_action:
            - url
            - username
            - password
            - proxyHost
            - proxyPort
            - proxyUsername
            - proxyPassword
            - connectTimeout
            - socketTimeout
            - headers
            - queryParams
            - contentType
            - method: "'GET'"
        publish:
            - return_result
            - error_message
            - return_code
            - status_code
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE
  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
  results:
    - SUCCESS : returnCode == '0'
    - FAILURE
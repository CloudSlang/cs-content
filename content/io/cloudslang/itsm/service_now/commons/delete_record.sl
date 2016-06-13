#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs a REST Delete request to any ServiceNow table.
#! @input host: required - URL of the ServiceNow instance
#!              Example: 'dev10000.service-now.com'
#! @input protocol: optional - protocol that is used to send the request
#!                  Valid: https. Obs: ServiceNow uses only this protocol
#!                  Default: https
#! @input auth_type: optional - type of authentication used to execute the request on the target server
#!                   Valid: 'basic', 'anonymous' (When OAuth token is provided). Obs: ServiceNow uses only these
#!                   Default: 'basic'
#! @input api_version: optional - the servicenow api version to be used for the call
#!                   Valid: 'v1'
#!                   Default: ''
#! @input system_id: required - system id of the ServiceNow record to be deleted
#!                   Example: 71c7ac460f811200ff7eb17ce1050e7a
#! @input table_name: required - name of the servicenow table which should be used for the request
#!                    Example: incident, problem , change
#! @input username: optional - username used for URL authentication
#! @input password: optional - password used for URL authentication
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - user name used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input connect_timeout: optional - time in seconds to wait for a connection to be established - Default: '0' (infinite)
#! @input socket_timeout: optional - time in seconds to wait for data to be retrieved - Default: '0' (infinite)
#! @input headers: optional - list containing the headers to use for the request separated by new line (CRLF);
#!                 header name - value pair will be separated by ":" - Format: According to HTTP standard for
#!                 headers (RFC 2616) - Example: 'Accept:text/plain'
#! @input query_params: optional - list containing query parameters to append to the URL
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#! @input content_type: optional - content type that should be set in the request header, representing the MIME-type of the
#!                      data in the message body - Default: 'application/json'
#! @output return_result: response of the operation in case of success or the error message otherwise
#! @output error_message: return_result if status_code is not contained in interval between '200' and '299'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: status code of the HTTP call
#!!#
################################################

namespace: io.cloudslang.itsm.service_now.commons

imports:
  rest: io.cloudslang.base.http

flow:
  name: delete_record

  inputs:
    - host
    - protocol:
        required: false
        default: "https"
    - auth_type:
        required: false
        default: "basic"
    - api_version:
        required: false
        default: ''
    - table_name
    - system_id:
        required: true
    - username:
        required: false
        default: ''
    - password:
        required: false
        default: ''
        sensitive: true
    - proxy_host:
        required: false
        default: ''
    - proxy_port:
        default: "8080"
        required: false
    - proxy_username:
        required: false
        default: ''
    - proxy_password:
        required: false
        default: ''
        sensitive: true
    - connect_timeout:
        default: "0"
        required: false
    - socket_timeout:
        default: "0"
        required: false
    - headers:
        required: false
        default: ''
    - query_params:
        required: false
        default: ''
    - content_type:
        default: "application/json"
        required: false
        private: true

  workflow:
    - delete_record:
        do:
          rest.http_client_delete:
            - url: ${protocol + '://' + host + '/api/now/' + api_version + '/table/' + table_name + '/' + system_id}
            - auth_type
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connect_timeout
            - socket_timeout
            - headers
            - query_params
            - content_type

        publish:
          - return_result
          - error_message
          - return_code
          - status_code

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

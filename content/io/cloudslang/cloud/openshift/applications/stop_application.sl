#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs a REST API call to stop an existing RedHat OpenShift Online application.
#! @input host: RedHat OpenShift Online host
#! @input username: RedHat OpenShift Online username
#!                  optional
#!                  example: 'someone@mailprovider.com'
#! @input password: RedHat OpenShift Online password used for authentication
#!                  optional
#! @input proxy_host: proxy server used to access RedHat OpenShift Online web site
#!                    optional
#! @input proxy_port: proxy server port
#!                    optional
#!                    default: '8080'
#! @input proxy_username: user name used when connecting to proxy
#!                        optional
#! @input proxy_password: proxy server password associated with <proxy_username> input value
#!                        optional
#! @input domain: name of RedHat OpenShift Online domain application belongs to
#! @input application_name: RedHat OpenShift Online application name that will be stopped
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#!!#
####################################################

namespace: io.cloudslang.cloud.openshift.applications

imports:
  rest: io.cloudslang.base.http

flow:
  name: stop_application
  inputs:
    - host
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - domain
    - application_name

  workflow:
    - stop_app:
        do:
          rest.http_client_post:
            - url: ${'https://' + host + '/broker/rest/domains/' + domain + '/applications/' + application_name + '/events'}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - content_type: 'application/json'
            - body: '{"event":"stop"}'
            - headers: 'Accept: application/json'
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

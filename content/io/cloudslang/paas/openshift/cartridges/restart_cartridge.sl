#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: This flow performs an REST API call in order to restart a running embedded cartridge.
#! @input host: RedHat OpenShift Online host
#! @input username: optional - the RedHat OpenShift Online username - Example: 'someone@mailprovider.com'
#! @input password: optional - the RedHat OpenShift Online password used for authentication
#! @input proxy_host: optional - proxy server used to access the RedHat OpenShift Online web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - user name used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input domain: the name of the RedHat OpenShift Online domain in which the application, that contain the specified
#!                cartridge, is
#! @input application_name: the RedHat OpenShift Online application name
#! @input cartridge: the name of the framework to be restarted
#! @output return_result: the response of the operation in case of success, the error message otherwise
#! @output error_message: return_result if statusCode is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: the code returned by the operation
#!!#
####################################################

namespace: io.cloudslang.paas.openshift.cartridges

imports:
  rest: io.cloudslang.base.network.rest
  list: io.cloudslang.base.lists

flow:
  name: restart_cartridge
  inputs:
    - host
    - username:
        required: false
    - password:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - domain
    - application_name
    - cartridge

  workflow:
    - restart_cartridge:
        do:
          rest.http_client_post:
            - url: ${'https://' + host + '/broker/rest/domains/' + domain + '/applications/' + application_name + '/cartridges/' + cartridge + '/events'}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - content_type: 'application/json'
            - body: '{"event":"restart"}'
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
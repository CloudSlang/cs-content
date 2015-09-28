#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs an REST API call in order to add an embedded cartridge to an specified RedHat OpenShift Online application
#
# Inputs:
#   - host - RedHat OpenShift Online host
#   - username - optional - the RedHat OpenShift Online username - Example: someone@mailprovider.com
#   - password - optional - the RedHat OpenShift Online password used for authentication
#   - proxy_host - optional - proxy server used to access the RedHat OpenShift Online web site
#   - proxy_port - optional - proxy server port - Default: "'8080'"
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxy_username> input value
#   - domain - the name of the RedHat OpenShift Online domain in which the application is
#   - application_name - the RedHat OpenShift Online application name to add cartridge to
#   - cartridge - the name of the embedded cartridge to be added - Valid values: "'mongodb-2.0'", "'cron-1.4'", "'mysql-5.1'",
#       "'postgresql-8.4'", "'haproxy-1.4'", "'10gen-mms-agent-0.1'", "'phpmyadmin-3.4'", "'metrics-0.1'", "'rockmongo-1.1'", "'jenkins-client-1.4'"
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if statusCode is not "201"
#   - return_code - "0" if success, "-1" otherwise
#   - status_code - the code returned by the operation
####################################################

namespace: io.cloudslang.paas.openshift.cartridges

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: add_cartridge
  inputs:
    - host
    - username:
        default: "''"
        required: false
    - password:
        default: "''"
        required: false
    - proxy_host:
        default: "''"
        required: false
    - proxy_port:
        default: "'8080'"
        required: false
    - proxy_username:
        default: "''"
        required: false
    - proxy_password:
        default: "''"
        required: false
    - domain
    - application_name
    - cartridge

  workflow:
    - add_cartridge:
        do:
          rest.http_client_post:
            - url: "'https://' + host + '/broker/rest/domains/' + domain + '/applications/' + application_name + '/cartridges'"
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - content_type: "'application/json'"
            - body: "'{\"cartridge\":\"' + cartridge + '\"}'"
            - headers: "'Accept: application/json'"
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
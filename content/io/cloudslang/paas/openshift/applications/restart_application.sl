#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs an REST API call in order to restart an existing and running RedHat OpenShift Online application
#
# Inputs:
#   - host - RedHat OpenShift Online host
#   - username - optional - the RedHat OpenShift Online username - Example: someone@mailprovider.com
#   - password - optional - the RedHat OpenShift Online password used for authentication
#   - proxy_host - optional - proxy server used to access the RedHat OpenShift Online web site
#   - proxy_port - optional - proxy server port - Default: "'8080'"
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxy_username> input value
#   - domain - the name of the RedHat OpenShift Online domain from where the application belongs to
#   - application_name - the RedHat OpenShift Online application name that will be restarted
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if statusCode is not "200"
#   - return_code - "0" if success, "-1" otherwise
#   - status_code - the code returned by the operation
####################################################

namespace: io.cloudslang.paas.openshift.applications

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: restart_application
  inputs:
    - host
    - username:
        required: false
    - password:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: "'8080'"
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - domain
    - application_name

  workflow:
    - restart_app:
        do:
          rest.http_client_post:
            - url: "'https://' + host + '/broker/rest/domains/' + domain + '/applications/' + application_name + '/events'"
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username:
                required: false
            - proxy_password:
                required: false
            - content_type: "'application/json'"
            - body: "'{\"event\":\"restart\"}'"
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
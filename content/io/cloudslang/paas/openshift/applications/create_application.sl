#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs an REST API call in order to create a new RedHat OpenShift Online application
#
# Inputs:
#   - host - RedHat OpenShift Online host
#   - username - optional - the RedHat OpenShift Online username - Example: 'someone@mailprovider.com'
#   - password - optional - the RedHat OpenShift Online password used for authentication
#   - proxy_host - optional - proxy server used to access the RedHat OpenShift Online web site
#   - proxy_port - optional - proxy server port - Default: '8080'
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxy_username> input value
#   - domain - the name of the RedHat OpenShift Online domain in which the application will be created
#              Note: The domain must be created first in order to can create applications
#   - application_name - the RedHat OpenShift Online application name
#   - cartridge - the list with names of the frameworks to be added in RedHat OpenShift Online application
#                 Example: ['ruby-1.8']
#   - scale - optional - mark RedHat OpenShift Online application as scalable - Default: False
#   - gear_profile - optional - size of the gear - Default: 'small'
#   - initial_git_url - optional - URL to Git source repository
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if statusCode is not '201'
#   - return_code - '0' if success, '-1' otherwise
#   - status_code - the code returned by the operation
####################################################

namespace: io.cloudslang.paas.openshift.applications

imports:
  rest: io.cloudslang.base.network.rest
  list: io.cloudslang.base.lists

flow:
  name: create_application
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
    - scale:
        default: False
        required: false
    - gear_profile:
        required: false
    - initial_git_url:
        required: false

  workflow:
    - cartridge_str:
        do:
          list.convert_list_to_string:
            - list: ${cartridge}
            - double_quotes: True
            - result_delimiter: ','
            - result_to_lowercase: True
        publish:
          - cartridge_str: ${result}
        navigate:
          SUCCESS: create_app
          FAILURE: CONVERT_LIST_TO_STRING_FAILURE

    - create_app:
        do:
          rest.http_client_post:
            - url: "${'https://' + host + '/broker/rest/domains/' + domain + '/applications'}"
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - content_type: 'application/json'
            - application_name_string: "${'\"name\":\"' + application_name + '\",'}"
            - cartridge_string: "${'\"cartridge\":[' + cartridge_str + ']'}"
            - scale_string: "${',\"scale\":' + str(scale).lower()}"
            - gear_profile_string: "${',\"gear_profile\":\"' + gear_profile + '\"' if gear_profile else ''}"
            - initial_git_url_string: "${',\"initial_git_url\":\"' + initial_git_url + '\"' if initial_git_url else ''}"
            - body: "${'{' + application_name_string + cartridge_string + gear_profile_string + initial_git_url_string + scale_string + '}'}"
            - headers: 'Accept: application/json'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CREATE_APPLICATION_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - CONVERT_LIST_TO_STRING_FAILURE
    - CREATE_APPLICATION_FAILURE
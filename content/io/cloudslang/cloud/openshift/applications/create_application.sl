#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs a REST API call to create a new RedHat OpenShift Online application.
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
#! @input domain: name of RedHat OpenShift Online domain in which application will be created
#!                note: domain must be created first in order to create applications
#! @input application_name: RedHat OpenShift Online application name
#! @input cartridge: list with names of frameworks to be added in RedHat OpenShift Online application
#!                   example: ['ruby-1.8']
#! @input scale: mark RedHat OpenShift Online application as scalable
#!               optional
#!               default: False
#! @input gear_profile: size of the gear
#!                      optional
#!                      default: 'small'
#! @input initial_git_url: URL to Git source repository
#!                         optional
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '201'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#! @result SUCCESS: new RedHat OpenShift Online application was created successfully
#! @result CONVERT_LIST_TO_STRING_FAILURE
#! @result CREATE_APPLICATION_FAILURE
#!!#
####################################################

namespace: io.cloudslang.cloud.openshift.applications

imports:
  rest: io.cloudslang.base.http
  list: io.cloudslang.base.lists

flow:
  name: create_application
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
    - cartridge
    - scale:
        default: False
        required: false
    - gear_profile:
        default: 'small'
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
          - SUCCESS: create_app
          - FAILURE: CONVERT_LIST_TO_STRING_FAILURE

    - create_app:
        do:
          rest.http_client_post:
            - url: ${'https://' + host + '/broker/rest/domains/' + domain + '/applications'}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - content_type: 'application/json'
            - application_name_string: ${'"name":"' + application_name + '",'}
            - cartridge_string: ${'"cartridge":[' + cartridge_str + ']'}
            - scale_string: ${',"scale":' + str(scale).lower()}
            - gear_profile_string: ${',"gear_profile":"' + gear_profile + '"' if gear_profile else ''}
            - initial_git_url_string: ${',"initial_git_url":"' + initial_git_url + '"' if initial_git_url else ''}
            - body: ${'{' + application_name_string + cartridge_string + gear_profile_string + initial_git_url_string + scale_string + '}'}
            - headers: 'Accept: application/json'

        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CREATE_APPLICATION_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - CONVERT_LIST_TO_STRING_FAILURE
    - CREATE_APPLICATION_FAILURE

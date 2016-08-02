#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves the ID of a specified flavor within an OpenStack project.
#! @input host: OpenStack machine host
#! @input identity_port: optional - port used for OpenStack authentication - Default: '5000'
#! @input compute_port: optional - port used for OpenStack computations - Default: '8774'
#! @input tenant_name: name of OpenStack project that contains images to be queried for ID
#! @input flavor_name: name of flavor to queried for ID
#! @input username: optional - username used for URL authentication; for NTLM authentication
#!                  Format: 'domain\user'
#! @input password: optional - password used for URL authentication
#! @input proxy_host: optional - proxy server used to access OpenStack services
#! @input proxy_port: optional - proxy server port used to access OpenStack services - Default: '8080'
#! @input proxy_username: optional - user name used when connecting to proxy
#! @input proxy_password: optional - proxy server password associated with <proxy_username> input value
#! @output flavor_id: ID of the flavor
#! @output return_result: response of operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by operation
#! @result SUCCESS: list with flavors were successfully retrieved
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: authentication token cannot be obtained
#!                                           from authentication call response
#! @result GET_TENANT_ID_FAILURE: tenant_id corresponding to tenant_name cannot be obtained
#!                                from authentication call response
#! @result GET_AUTHENTICATION_FAILURE: authentication call fails
#! @result LIST_FLAVORS_FAILURE: list with flavors could not be retrieved
#! @result EXTRACT_FLAVORS_FAILURE: list with flavors could not be retrieved from list flavors REST API call
#! @result EXTRACT_FLAVOR_ID_FAILURE: parsing of flavor ID was unsuccessful
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack.flavors

imports:
  flavors: io.cloudslang.cloud.openstack.flavors

flow:
  name: get_flavor_id_flow
  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - tenant_name
    - flavor_name
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

  workflow:
    - list_flavors:
        do:
          flavors.list_flavors:
            - host
            - identity_port
            - compute_port
            - tenant_name
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - flavor_list
        navigate:
          - SUCCESS: get_flavor_id
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - LIST_FLAVORS_FAILURE: LIST_FLAVORS_FAILURE
          - EXTRACT_FLAVORS_FAILURE: EXTRACT_FLAVORS_FAILURE

    - get_flavor_id:
        do:
          flavors.get_flavor_id:
            - flavor_body: ${return_result}
            - flavor_name: ${flavor_name}
        publish:
          - flavor_id
          - return_result
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: EXTRACT_FLAVOR_ID_FAILURE

  outputs:
    - flavor_id
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - LIST_FLAVORS_FAILURE
    - EXTRACT_FLAVORS_FAILURE
    - EXTRACT_FLAVOR_ID_FAILURE

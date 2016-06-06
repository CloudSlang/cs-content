#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Waits for a droplet to change its status.
#! @input droplet_id: id of the droplet
#! @input status: status to wait upon; will wait until the droplet status is changed or timeout is reached
#!                Valid: "new", "active", "off", "archive"
#! @input timeout: time limit to wait for droplet to change its status as number or string - in seconds
#! @input token: personal access token for DigitalOcean API
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @input proxy_username: optional - user name used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input connect_timeout: optional - time to wait for a connection to be established, in seconds (0 represents infinite value)
#! @input socket_timeout: optional - time to wait for data to be retrieved, in seconds (0 represents infinite value)
#! @result SUCCESS: droplet changed its status
#! @result DROPLET_NOT_FOUND: underlying GET request returned NOT_FOUND status code for droplet
#! @result FAILURE: error occurred
#! @result TIMEOUT: droplet did not change its status until the time limit
#!!#
########################################################################################################
namespace: io.cloudslang.cloud.digital_ocean.v2.utils

imports:
  droplets: io.cloudslang.cloud.digital_ocean.v2.droplets
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils
  math: io.cloudslang.base.math

flow:
  name: wait_for_status_to_change

  inputs:
    - droplet_id
    - status
    - timeout
    - token:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false
    - time_left:
        default: ${int(timeout)}
        private: true

  workflow:
    - get_droplet_status:
        do:
          droplets.retrieve_droplet_by_id:
            - droplet_id
            - token
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connect_timeout
            - socket_timeout
        publish:
          - actual_status: ${droplet_status}
          - status_code
        navigate:
          - SUCCESS: check_status
          - FAILURE: check_droplet_not_found

    - check_droplet_not_found:
        do:
          strings.string_equals:
            - first_string: '404'
            - second_string: ${status_code}
        navigate:
          - SUCCESS: DROPLET_NOT_FOUND
          - FAILURE: FAILURE

    - check_status:
        do:
          strings.string_equals:
            - first_string: ${status}
            - second_string: ${actual_status}
        navigate:
          - SUCCESS: check_timeout
          - FAILURE: SUCCESS

    - check_timeout:
        do:
          math.compare_numbers:
            - value1: ${time_left}
            - value2: 0
            - time_left
        publish:
          - time_left: ${time_left - 1}
        navigate:
          - GREATER_THAN: sleep
          - EQUALS: TIMEOUT
          - LESS_THAN: TIMEOUT

    - sleep:
        do:
          utils.sleep:
            - seconds: 1
        navigate:
          - SUCCESS: get_droplet_status
          - FAILURE: FAILURE
  results:
    - SUCCESS
    - DROPLET_NOT_FOUND
    - FAILURE
    - TIMEOUT

#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks if a url is accessible.
#! @input url: the url
#! @input time_to_sleep: time in seconds to wait
#! @output output_message: timeout exceeded and url was not accessible
#! @result SUCCESS: url is accessible
#! @result FAILURE: url is not accessible
#!!#
####################################################

namespace: io.cloudslang.base.network

imports:
  math: io.cloudslang.base.math
  rest: io.cloudslang.base.http
  utils: io.cloudslang.base.utils
flow:
  name: verify_url_is_accessible
  inputs:
    - url
    - time_to_sleep:
        default: '1'
        required: false
    - content_type:
        default: "application/json"
  workflow:

    - http_get:
        do:
          rest.http_client_get:
            - url
            - content_type
            - connect_timeout: "20"

        publish:
          - return_code

        navigate:
          - SUCCESS: wait
          - FAILURE: check_if_timed_out

    - check_if_timed_out:
         do:
            math.compare_numbers:
              - value1: ${return_code}
              - value2: '-1'
         navigate:
           - GREATER_THAN: wait
           - EQUALS: FAILURE
           - LESS_THAN: FAILURE

    - wait:
        do:
          utils.sleep:
              - seconds: ${time_to_sleep}

        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - return_code
    - output_message: ${"Url is accessible" if return_code == '0' else "Url is not accessible"}


  results:
    - SUCCESS
    - FAILURE
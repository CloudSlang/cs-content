#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks the status of a Haven OnDemand job, including results if the job is finished.
#! @input api_key: user's API Keys
#! @input job_id: id of request returned by Haven OnDemand
#! @input proxy_host: proxy server
#!                    optional
#! @input proxy_port: proxy server port
#!                    optional
#! @output status: status of request
#! @output return_result: JSON result of from API call
#! @output error_message: error message if one exists, empty otherwise
#! @result FINISHED: status is finished
#! @result IN_PROGRESS: status is in progress
#! @result QUEUED: status is queued
#! @result FAILURE: status is failure
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.utils

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  print: io.cloudslang.base.print
  hod: io.cloudslang.haven_on_demand

flow:
  name: check_status

  inputs:
    - api_key:
        sensitive: true
    - result_url:
        default: "https://api.havenondemand.com/1/job/status/"
        private: true
    - job_id
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - check_status:
        do:
          http.http_client_get:
            - url: ${str(result_url) + str(job_id) + "?apikey=" + str(api_key)}
            - proxy_host
            - proxy_port
        publish:
          - error_message
          - return_result
    - extract_status:
        do:
          json.get_value:
             - json_input: ${return_result}
             - json_path: ${['actions', 0, 'status']}
        publish:
          - value
          - error_message
    - evaluate_status:
        do:
          hod.utils.evaluate_status:
            - status: ${value}
        navigate:
          - FINISHED: FINISHED
          - IN_PROGRESS: IN_PROGRESS
          - QUEUED: QUEUED
          - FAILURE: on_failure
    - on_failure:
        - print_fail:
            do:
              print.print_text:
                  - text: ${"Error - " + error_message}
  outputs:
    - status: ${value}
    - return_result
    - error_message

  results:
    - FINISHED
    - IN_PROGRESS
    - QUEUED
    - FAILURE

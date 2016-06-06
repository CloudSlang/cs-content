
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Gets results of Speech Recognition, which was made by HPE Haven OnDemand API.
#! @input speech_result_api: API which waits until the job has finished and then returns the result
#! @input api_key: user's API Keys
#! @input job_id: name of request returned by havenondemand.com
#! @output status: status of request
#! @output result: JSON result of from API
#! @output transcript: results of speech recognition
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.speech_recognition

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  file: io.cloudslang.base.files
  base: io.cloudslang.base.print
flow:
  name: check_status

  inputs:
    - speech_result_api
    - job_id
    - api_key:
        sensitive: true

  workflow:
     - check_status:
          do:
            http.http_client_get:
               - url: ${str(speech_result_api) + str(job_id) + "?apikey=" + str(api_key)}

          publish:
             - error_message
             - return_result
             - return_code
             - status_code
          navigate:
             - SUCCESS: get_status_recognition
             - FAILURE: wait_for_recognition

     - wait_for_recognition:
          loop:
             for: counter in range (0,5)
             do:
              http.http_client_get:
                 - url: ${str(speech_result_api) + str(job_id) + "?apikey=" + str(api_key)}

             publish:
               - error_message
               - return_result
               - return_code
               - status_code
             break:
                - SUCCESS
          navigate:
             - SUCCESS: get_status_recognition
             - FAILURE: print_fail

     - get_status_recognition:
            do:
              json.get_value:
                - json_input: ${return_result}
                - json_path: ['status']
            publish:
              - status: ${value}
              - error_message
            navigate:
                - SUCCESS: get_result_recognition
                - FAILURE: fail_get_status

     - fail_get_status:
          do:
            base.print_text:
                - text: "${'get_status_recognition was faild with 'error_message}"

     - get_result_recognition:
          do:
            json.get_value:
              - json_input: ${return_result}
              - json_path: ['actions',0,'result','document',0,'content']
          publish:
            - transcript: ${value}
            - error_message

     - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                        - text: "${error_message}"
  outputs:
      - result: ${return_result}
      - transcript : ${transcript}
      - status: ${status}

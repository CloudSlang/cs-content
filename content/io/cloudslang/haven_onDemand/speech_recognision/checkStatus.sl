
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Gets results of Speech Recognision, with was made by HPE Haven OnDemand API.
#! @input speechResultApi: API which waits until the job has finished and then returns the result
#! @input apikey: user's API Keys
#! @input jobID: name of request, witch is returned by havenondemand.com
#! @output status: status of request
#! @output result: JSON result of  from API
#! @output transcript: results of Speech Recognision
#!!#
####################################################

namespace: io.cloudslang.haven_onDemand.speech_recognision

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json
  file: io.cloudslang.base.files
  base: io.cloudslang.base.print
flow:
  name: checkStatus

  inputs:
    - speechResultApi
    - jobID
    - apikey

  workflow:
     - checkStatus:
          do:
            rest.http_client_get:
               - url: ${str(speechResultApi) + str(jobID) + "?apikey=" + str(apikey)}

          publish:
             - error_message
             - return_result
             - return_code
             - status_code
          navigate:
             - SUCCESS: get_status_recognision
             - FAILURE: wait_for_recognision

     - wait_for_recognision:
          loop:
             for: counter in range (0,5)
             do:
              rest.http_client_get:
                 - url: ${str(speechResultApi) + str(jobID) + "?apikey=" + str(apikey)}
                 - proxy_host: proxy.houston.hp.com
                 - proxy_port: '8080'
             publish:
               - error_message
               - return_result
               - return_code
               - status_code
             break:
                - status_code: 200
          navigate:
             - SUCCESS: get_status_recognision
             - FAILURE: print_fail

     - get_status_recognision:
            do:
              json.get_value:
                - json_input: ${return_result}
                - json_path: ['status']
            publish:
              - status: ${value}
              - error_message
            navigate:
                - SUCCESS: get_result_recognision
                - FAILURE: fail_get_status

     - fail_get_status:
          do:
            base.print_text:
                - text: "${'get_status_recognision was faild with 'error_message}"

     - get_result_recognision:
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

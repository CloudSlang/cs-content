
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
#! @input url: URL to Speech Recognision API
#! @input apikey: user's API Keys
#! @input jobID: name of request, witch is returned by havenondemand.com
#! @output result: JSON result of  from API
#! @output resultOfRecogn: results of Speech Recognision
#!!#
####################################################

namespace: io.cloudslang.haven_onDemand.voice_recognision

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json
  file: io.cloudslang.base.files
  base: io.cloudslang.base.print
flow:
  name: checkStatus

  inputs:
    - url
    - jobID
    - apikey
    - proxy_host:
        required: false
    - proxy_port:
       required: false

  workflow:
     - checkStatus:
          do:
            rest.http_client_get:
               - url: ${str(url) + str(jobID) + "?apikey=" + str(apikey)}
               - proxy_host: proxy.houston.hp.com
               - proxy_port: '8080'
          publish:
             - error_message
             - return_result
             - return_code
          navigate:
               SUCCESS: get_result_value
               FAILURE: checkStatus

     - get_result_value:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['actions',0,'result','document',0,'content']

        publish:
          - value
          - error_message

     - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                        - text: "${error_message}"
  outputs:
      - result: ${return_result}
      - resultOfRecogn: ${value if error_message=='' else 0}
  results:
    - SUCCESS: ${error_message==''}
    - FAILURE

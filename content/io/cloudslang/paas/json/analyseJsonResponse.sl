#################################################### 
# This flow analyse a json input, that is the result of a heroku's api call 
# 
# Inputs: 
#   - json_response - the result of the API call.
#
# Outputs: 
#   - returnResult: 0 if the API call succed, -1 if not
#   - idTypeResult: the id of the API call response
#
# Results:
#   - FAILURE: if an error has occured
#   - SUCCESS: if the response_type was equal to 0
#   - UNAUTHORIZED: represent the value of the API response id
#   - NOT_FOUND: represent the value of the API response id
#   - INVALID_PARAMS: represent the value of the API response id
#   - BAD_REQUEST: represent the value of the API response id
#   - VERIFICATION_REQUIRED: represent the value of the API response id
####################################################

namespace: io.cloudslang.paas.heroku.json

operation:
  name: analyseJsonResponse  
  inputs:
    - json_response
  action:
    python_script: |
      import json
      j = json.loads(json_response)
      response_type = '0'
      try:
        r = j['id']
        if r in ['unauthorized', 'not_found', 'invalid_params', 'bad_request', 'verification_required']:
          response_type = '-1'
      except:
        print "json is an array"
        r = "Array"

  outputs:
    - returnResult: ${response_type}
    - idTypeResult: ${r}
  results: 
    - SUCCESS: ${response_type == '0'}
    - UNAUTHORIZED: ${r == 'unauthorized'}
    - NOT_FOUND: ${r == 'not_found'}
    - INVALID_PARAMS: ${r == 'invalid_params'}
    - BAD_REQUEST: ${r == 'bad_request'}
    - VERIFICATION_REQUIRED: ${r == 'verification_required'}
    - FAILURE
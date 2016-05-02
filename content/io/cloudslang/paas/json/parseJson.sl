

namespace: io.cloudslang.paas.heroku.json

operation:
  name: parseJson  
  inputs:
    - json_input
  action:
    python_script: |
      import json
      j = json.loads(json_input)
      resultArray = []
      for current in range(len(j)):
        resultCurrent = []
        r = j[current]
        resultCurrent = [r['id'], r['name']]
        resultArray.append(resultCurrent)
  outputs:
    - resultTab: resultArray
  # results:  
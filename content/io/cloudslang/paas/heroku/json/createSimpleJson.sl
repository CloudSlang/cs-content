#################################################### 
# This flow creates a json output from a list 
# 
# Inputs: 
#   - list - the list that will be convert into Json. The format is : key:value|key:value.
#             the "" will be automatically add the keys, but need to be put on the values if needed
#             Exemple : name:"John"|age:35|isDoe:true
#
# Outputs: 
#   - json: the json that represent the list 
#
# Results:
#   - FAILURE: if an error has occured
#   - SUCCESS: if the json was created
####################################################

namespace: io.cloudslang.paas.heroku.json

operation:
  name: createSimpleJson  
  inputs:
    - list
  action:
    python_script: |
      error = 0
      if len(list) <= 0:
        error = -1
      jsonParameters = list.split("|")
      json = "{"
      jsonTab = []
      for current in range(len(jsonParameters)):
        parameter = jsonParameters[current].split(":")
        key = parameter[0]
        value = parameter[1]
        if (len(value) >2 ):
          jsonTab.append("\"" + key + "\":" + value)
      json += ','.join(jsonTab)
      json += "}"
      print json
  outputs:
    - json: ${json}
  results:
    - FAILURE: ${ error == -1 }
    - SUCCESS
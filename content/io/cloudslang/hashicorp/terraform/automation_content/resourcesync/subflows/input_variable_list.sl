namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
operation:
  name: input_variable_list
  inputs:
    - data
  python_action:
    use_jython: false
    script: "# do not remove the execute function\r\nimport json\r\ndef execute(data):\r\n    json_load = (json.loads(data))\r\n    myval = ''\r\n   \r\n    for i in json_load['data']:\r\n        val='empty'\r\n        if i['attributes']['value'] != None:\r\n            val = i['attributes']['value']\r\n        if myval == '':\r\n            myval = i['attributes']['key']+':::'+val+':::'+str(i['attributes']['sensitive'])\r\n        else:\r\n             myval = myval + ','+i['attributes']['key']+':::'+val+':::'+str(i['attributes']['sensitive'])\r\n    return{\"return_result\":myval}\r\n        \r\n    # code goes here\r\n# you can add additional helper methods below."
  outputs:
    - return_result
  results:
    - SUCCESS

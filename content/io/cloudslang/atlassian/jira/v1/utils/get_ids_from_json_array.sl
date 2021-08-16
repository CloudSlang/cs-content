namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_ids_from_json_array
  inputs:
    - data_json:
        required: true
    - array_name:
        required: true
  python_action:
    use_jython: false
    script: "import json\n\ndef execute(data_json, array_name):\n    \n    if data_json == \"\":\n        return {\"return_result\": \"\", \"return_code\": -1}\n        \n    ids = \"\"\n    \n    for element in json.loads(data_json)[array_name]:\n        ids += element[\"id\"] + \",\"\n        \n    ids = ids[:-1]\n    \n    return {\"return_result\": ids, \"return_code\": 0}"
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
  results:
    - SUCCESS

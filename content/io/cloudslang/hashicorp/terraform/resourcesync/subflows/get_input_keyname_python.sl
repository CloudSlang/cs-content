namespace: io.cloudslang.hashicorp.terraform.resourcesync.subflows
operation:
  name: get_input_keyname_python
  inputs:
    - input_results
  python_action:
    use_jython: false
    script: "import json\n\n\ndef execute(input_results):\n\n    key = ' '\n    input_results_keyname_list = []\n    input_results_keyvalue_list = []\n    y = json.loads(input_results)\n    result = {}\n\n    for key in y.keys():\n        input_results_keyname_list.append(key)\n        x = list(y[key])\n        input_results_keyvalue_list.append(y[key]['value'])\n        result[key] = y[key]['value']\n    \n    input_results_keyname_list = str(input_results_keyname_list)\n    #input_results_keyname_list = input_results_keyname_list.replace(\"'\", \"\").replace(\"[\", \"\").replace(\"]\", \"\")\n    input_results_keyvalue_list = str(input_results_keyvalue_list)\n    #input_results_keyvalue_list = input_results_keyvalue_list.replace(\"'\", \"\").replace(\"[\", \"\").replace(\"]\", \"\")\n    return {'result': result, 'input_results_keyname_list': input_results_keyname_list, 'input_results_keyvalue_list': input_results_keyvalue_list}"
  outputs:
    - input_results_keyname_list
    - input_results_keyvalue_list
    - result
  results:
    - SUCCESS

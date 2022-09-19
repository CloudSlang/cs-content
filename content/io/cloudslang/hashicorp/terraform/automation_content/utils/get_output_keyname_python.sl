namespace: io.cloudslang.hashicorp.terraform.automation_content.utils
operation:
  name: get_output_keyname_python
  inputs:
    - output_results
  python_action:
    use_jython: false
    script: "import json\n\n\ndef execute(output_results):\n\n    key = ' '\n    output_results_keyname_list = []\n    output_results_keyvalue_list = []\n    y = json.loads(output_results)\n    result = {}\n\n    for key in y.keys():\n        output_results_keyname_list.append(key)\n        x = list(y[key])\n        output_results_keyvalue_list.append(y[key]['value'])\n        result[key] = y[key]['value']\n    \n    output_results_keyname_list = str(output_results_keyname_list)\n    output_results_keyname_list = output_results_keyname_list.replace(\"'\", \"\").replace(\"[\", \"\").replace(\"]\", \"\")\n    output_results_keyvalue_list = str(output_results_keyvalue_list)\n    output_results_keyvalue_list = output_results_keyvalue_list.replace(\"'\", \"\").replace(\"[\", \"\").replace(\"]\", \"\")\n    return {'result': result, 'output_results_keyname_list': output_results_keyname_list, 'output_results_keyvalue_list': output_results_keyvalue_list}"
  outputs:
    - output_results_keyname_list
    - output_results_keyvalue_list
    - result
  results:
    - SUCCESS

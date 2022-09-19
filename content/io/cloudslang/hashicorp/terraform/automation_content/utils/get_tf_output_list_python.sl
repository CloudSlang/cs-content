namespace: io.cloudslang.hashicorp.terraform.automation_content.utils
operation:
  name: get_tf_output_list_python
  inputs:
    - property_value_list
  python_action:
    use_jython: false
    script: "import json\ndef execute(property_value_list):\n    piplined_list = property_value_list.split(\"|\")\n    tf_output_list = []\n    for value in piplined_list:\n        if value[:9] == \"tf_output\":\n            tf_output_list.append(value)\n    \n    tf_output_list = str(tf_output_list).replace(\"[\", \"\").replace(\"]\", \"\").replace(\"'\", \"\")              \n    return {\"tf_output_list\": tf_output_list}"
  outputs:
    - tf_output_list
  results:
    - SUCCESS

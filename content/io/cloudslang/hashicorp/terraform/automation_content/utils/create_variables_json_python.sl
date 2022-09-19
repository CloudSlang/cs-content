namespace: io.cloudslang.hashicorp.terraform.automation_content.utils
operation:
  name: create_variables_json_python
  inputs:
    - property_value_list
  python_action:
    use_jython: false
    script: "import json\ndef execute(property_value_list):\n    piplined_separated_list = property_value_list.split(\"|\")\n    value_separated_list = []\n    sensitive_json = []\n    non_sensitive_json = []\n    \n    for value in piplined_separated_list:\n        if value[:8] == \"tf_input\":\n            value_separated_list.append(value)\n            if value.split(\";\")[2] == \"false\":\n                non_sensitive_json.append({\n                    \"propertyName\": str(value.split(\";\")[0]).replace(\"tf_input_\", \"\"),\n                    \"propertyValue\": value.split(\";\")[1],\n                    \"HCL\": False,\n                    \"Category\":\"terraform\"})\n            else:\n                sensitive_json.append({\n                    \"propertyName\": str(value.split(\";\")[0]).replace(\"tf_input_\", \"\"),\n                    \"propertyValue\": value.split(\";\")[1],\n                    \"HCL\": False,\n                    \"Category\":\"terraform\"})\n                \n    return {\"sensitive_json\": json.dumps(sensitive_json), \"non_sensitive_json\": json.dumps(non_sensitive_json)}"
  outputs:
    - sensitive_json
    - non_sensitive_json
  results:
    - SUCCESS

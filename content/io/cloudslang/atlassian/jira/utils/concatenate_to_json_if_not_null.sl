########################################################################################################################
#!!
#! @description: Checks if a key/value is null and if not, it appends it to an existing json structure without adding the ending brace
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.utils
operation:
  name: concatenate_to_json_if_not_null
  inputs:
    - init_json
    - new_key:
        required: true
    - new_value:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\n#checks if a key/value is null and if not, it appends it to an existing json structure\n#without adding the ending brace\ndef execute(init_json, new_key, new_value):\n    returnCode = 0\n    appended_json = init_json\n    if bool(init_json) == False or bool(new_key) == False:\n       returnCode = -1;\n    elif bool(new_value) == False:\n        returnCode = 0;\n    else:\n       appended_json = appended_json + ', \"' + new_key + '\":\"' + new_value + '\"';\n    \n    return {\"returnCode\": returnCode, \"appended_json\": appended_json}"
  outputs:
    - appended_json
  results:
    - SUCCESS: "${returnCode == '0'}"
    - FAILURE

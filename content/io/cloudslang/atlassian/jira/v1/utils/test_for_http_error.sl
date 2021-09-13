########################################################################################################################
#!!
#! @description: Retrieves the error message from the return result.
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: test_for_http_error
  inputs:
    - return_result
  python_action:
    use_jython: false
    script: "import json\n\ndef execute(return_result):\n    \n    error_message = \"\"\n    \n    try:\n        error_message = json.loads(return_result)[\"errorMessages\"][0]\n    except:\n        error_message = return_result\n        \n    return {\"error_message\": error_message}"
  outputs:
    - error_message: '${error_message}'
  results:
    - FAILURE

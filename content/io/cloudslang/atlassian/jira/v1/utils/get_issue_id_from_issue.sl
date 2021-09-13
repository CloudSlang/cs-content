########################################################################################################################
#!!
#! @description: Gets the issue id
#!
#! @result FAILURE: Operation failed
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_issue_id_from_issue
  inputs:
    - return_result:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\nimport json\ndef execute(return_result):\n    return_code = 0\n    issue_id = \"\"\n    try:\n        response = json.loads(return_result)\n        issue_id = response[\"id\"]\n    except:   \n        return_code = -1\n    \n    return {\"issue_id\" : issue_id, \"return_code\" : return_code}"
  outputs:
    - issue_id
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE


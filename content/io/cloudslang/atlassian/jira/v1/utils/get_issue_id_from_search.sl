########################################################################################################################
#!!
#! @description: Gets a comma separated list of isse ids
#!
#! @result FAILURE: Operation failed
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_issue_id_from_search
  inputs:
    - return_result:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\nimport json\ndef execute(return_result):\n    return_code = 0\n    issues_list = \"\"\n    try:\n        response = json.loads(return_result)\n        total_issues = response[\"issues\"]\n        for issue in total_issues:\n            issues_list = issues_list + issue[\"id\"] + ','\n        issues_list = issues_list[:-1]\n    except:   \n        return_code = -1\n    \n    return {\"issues_list\" : issues_list, \"return_code\" : return_code}"
  outputs:
    - issues_list
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE

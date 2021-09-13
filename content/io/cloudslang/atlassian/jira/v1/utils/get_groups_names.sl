########################################################################################################################
#!!
#! @description: Gets a comma separated list of isse ids
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_groups_names
  inputs:
    - return_result:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\nimport json\ndef execute(return_result):\n    return_code = 0\n    groups_list = \"\"\n    try:\n        response = json.loads(return_result)\n        total_groups = response[\"values\"]\n        for group in total_groups:\n            groups_list = groups_list + group[\"name\"] + ','\n        groups_list = groups_list[:-1]\n    except:   \n        return_code = -1\n    \n    return {\"groups_list\" : groups_list, \"return_code\" : return_code}"
  outputs:
    - groups_list
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE

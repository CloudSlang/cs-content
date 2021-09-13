########################################################################################################################
#!!
#! @description: Gets a comma separated list of isse ids
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_keys_and_ids_for_permitted_projects
  inputs:
    - return_result:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\nimport json\ndef execute(return_result):\n    return_code = 0\n    keys_list = \"\"\n    ids_list = \"\"\n    try:\n        response = json.loads(return_result)\n        projects = response[\"projects\"]\n        for project in projects:\n            keys_list = keys_list + project[\"key\"] + ','\n            ids_list =  ids_list + str(project[\"id\"]) + ','\n        keys_list = keys_list[:-1]\n        ids_list = ids_list[:-1]\n    except:   \n        return_code = -1\n    \n    return {\"keys_list\" : keys_list, \"ids_list\" : ids_list, \"return_code\" : return_code}"
  outputs:
    - keys_list
    - ids_list
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE

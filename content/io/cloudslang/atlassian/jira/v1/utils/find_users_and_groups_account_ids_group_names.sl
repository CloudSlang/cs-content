namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: find_users_and_groups_account_ids_group_names
  inputs:
    - return_result
  python_action:
    use_jython: false
    script: |-
      import json

      def execute(return_result):
          account_ids = ""
          group_names = ""
          json_obj = json.loads(return_result)
          for user in json_obj["users"]["users"]:
              account_ids = account_ids + user["accountId"] + ","
          account_ids = account_ids[:-1]
          for goup in json_obj["groups"]["groups"]:
              group_names = group_names + group["name"] + ","
          group_names = group_names[:-1]
          return{"account_ids":account_ids,"group_names":group_names}
  outputs:
    - account_ids
    - group_names
  results:
    - SUCCESS

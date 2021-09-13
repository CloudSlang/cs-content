namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_users_from_group_account_ids
  inputs:
    - return_result
  python_action:
    use_jython: false
    script: |-
      import json

      def execute(return_result):
          account_ids = ""
          json_obj = json.loads(return_result)
          for user in json_obj["values"]:
              account_ids = account_ids + user["accountId"] + ","
          account_ids = account_ids[:-1]
          return{"account_ids":account_ids}
  outputs:
    - account_ids
  results:
    - SUCCESS

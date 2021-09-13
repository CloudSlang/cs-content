namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_all_users_account_ids
  inputs:
    - return_result
  python_action:
    use_jython: false
    script: |-
      import json

      def execute(return_result):
          account_ids = ""
          json_obj = json.loads(return_result)
          for account_id in json_obj:
              account_ids = account_ids + account_id["accountId"] + ","
          account_ids = account_ids[:-1]
          return{"account_ids":account_ids}
  outputs:
    - account_ids
  results:
    - SUCCESS

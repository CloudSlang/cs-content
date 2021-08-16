namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_user_groups_group_names
  inputs:
    - return_result
  python_action:
    use_jython: false
    script: |-
      import json

      def execute(return_result):
          group_names = ""
          json_obj = json.loads(return_result)
          for group_name in json_obj:
              group_names = group_names + group_name["name"] + ","
          group_names = group_names[:-1]
          return{"group_names":group_names}
  outputs:
    - group_names
  results:
    - SUCCESS

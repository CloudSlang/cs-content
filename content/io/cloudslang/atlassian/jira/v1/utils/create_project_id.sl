namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: create_project_id
  inputs:
    - return_result
  python_action:
    use_jython: false
    script: |-
      import json

      def execute(return_result):
          json_obj = json.loads(return_result)
          id = json_obj["id"]
          return{"id":id}
  outputs:
    - id
  results:
    - SUCCESS

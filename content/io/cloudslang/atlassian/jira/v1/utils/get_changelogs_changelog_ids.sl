namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_changelogs_changelog_ids
  inputs:
    - return_result
  python_action:
    use_jython: false
    script: |-
      import json

      def execute(return_result):
          changelog_ids = ""
          json_obj = json.loads(return_result)
          for changelog in json_obj["values"]:
              changelog_ids = changelog_ids + changelog["id"] + ","
          changelog_ids = changelog_ids[:-1]
          return{"changelog_ids":changelog_ids}
  outputs:
    - changelog_ids
  results:
    - SUCCESS

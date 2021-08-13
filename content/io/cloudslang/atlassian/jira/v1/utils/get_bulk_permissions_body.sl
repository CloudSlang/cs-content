namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_bulk_permissions_body
  inputs:
    - project_permissions:
        required: false
    - global_permissions:
        required: false
    - account_id:
        required: false
  python_action:
    use_jython: false
    script: "def execute(project_permissions, global_permissions, account_id):\n    \n    return_code = 0;\n    body = \"{\"\n    \n    if global_permissions != \"\":\n        body += '\"globalPermissions\": [' + \"\".join(map(lambda permission: '\"' + permission + '\",', global_permissions.split(\",\")))[:-1] + ']'\n        \n    if account_id != \"\":\n        \n        if body != \"{\": \n            body += \",\"\n            \n        body += '\"accountId\": \"' + account_id + '\"'\n        \n    if project_permissions != \"\":\n        \n        if body != \"{\": \n            body += \",\"\n            \n        body += '\"projectPermissions\": [' + project_permissions + ']'\n        \n    body += \"}\"\n    \n    return {\"return_result\": body, \"return_code\": return_code}"
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
  results:
    - SUCCESS

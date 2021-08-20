namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: create_body_update_user_role
  inputs:
    - id_actual_user_role
    - id_new_user_role
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(id_actual_user_role, id_new_user_role):
          body='{"workspace_roles": {"data": [{"type": "workspace_role","id": "'+id_actual_user_role+'"} , {"type": "workspace_role","id": "'+id_new_user_role+'"} ]}}'
          return locals()
      # you can add additional helper methods below.
  outputs:
    - body
  results:
    - SUCCESS

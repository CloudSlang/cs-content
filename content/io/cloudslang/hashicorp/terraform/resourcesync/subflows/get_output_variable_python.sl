namespace: io.cloudslang.hashicorp.terraform.resourcesync.subflows
operation:
  name: get_output_variable_python
  inputs:
    - output_variable_list
  python_action:
    use_jython: false
    script: |-
      import json


      def execute(output_variable_list):

          key = ' '
          output_variable_key_list = []
          y = json.loads(output_variable_list)
          for key in y.keys():
              output_variable_key_list.append(key)
          return {'output_variable_key_list': output_variable_key_list}
  outputs:
    - output_variable_key_list
  results:
    - SUCCESS

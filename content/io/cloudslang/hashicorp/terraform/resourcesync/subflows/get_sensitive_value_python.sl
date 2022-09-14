namespace: io.cloudslang.hashicorp.terraform.resourcesync.subflows
operation:
  name: get_sensitive_value_python
  inputs:
    - input_results_keyname
    - input_keyname_keyvalue_list
    - original_keyname
  python_action:
    use_jython: false
    script: |-
      import ast
      def execute(input_results_keyname, input_keyname_keyvalue_list, original_keyname):
          output = ' '
          input_results_keyname = ast.literal_eval(input_results_keyname)
          input_keyname_keyvalue_list = ast.literal_eval(input_keyname_keyvalue_list)
          for retrieved_keyname in input_results_keyname:
              if retrieved_keyname == original_keyname:
                  output = retrieved_keyname
                  value = input_keyname_keyvalue_list[retrieved_keyname]
          return {"retrieved_keyname": output, "retrieved_keyvalue": value}
  outputs:
    - retrieved_keyname
    - retrieved_keyvalue
  results:
    - SUCCESS

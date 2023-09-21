########################################################################################################################
#!!
#! @description: This operation takes the key and returns the value as comma separated string.  Returns an empty string if the key is not present.
#!
#! @input json_body: The JSON in the form of a string. Example: {'key1': 'value1', 'key2': 'value2'}.
#! @input path_variable: The key whose value has to be returned.
#!
#! @output return_result: If successful, returns the values of the given path_variable
#!
#! @result SUCCESS: The values were successfully retrived
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2.networks.subnetworks.utils
operation:
  name: gcp_get_json_path_values
  inputs:
    - json_body
    - path_variable
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      import json
      def execute(json_body,path_variable):
          data = json.loads(json_body)
          path_variable = [item.get(path_variable, "") for item in data.get("items", [])]
          result = ",".join(map(str, path_variable))
          return {"return_result":result}
  outputs:
    - return_result
  results:
    - SUCCESS


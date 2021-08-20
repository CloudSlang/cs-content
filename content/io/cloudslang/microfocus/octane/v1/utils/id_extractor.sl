########################################################################################################################
#!!
#! @input return_result: The result in JSON format returned by the REST API call.
#!
#! @output entity_id: The id of the entity that's been modified in the current flow.
#! @output id_list: The list of id's for the entities within the current flow, in case of multiple entries.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: id_extractor
  inputs:
    - return_result:
        required: false
  python_action:
    use_jython: false
    script: |-
      import json
      # do not remove the execute function
      def execute(return_result):
          # code goes here
          try:
              id_list = []
              data = json.loads(return_result)
              if len(data["data"]) > 1:
                  for i in range(len(data["data"])):
                      id_list.append(data["data"][i]["id"])
              entity_id = data["data"][0]["id"]
          except Exception as e:
              return_code = 1
              error_message = str(e)

          return locals()
      # you can add additional helper methods below.
  outputs:
    - entity_id
    - id_list
  results:
    - SUCCESS

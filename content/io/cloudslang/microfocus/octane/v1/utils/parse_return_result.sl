namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: parse_return_result
  inputs:
    - text
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      import json
      def execute(text):
          json_object=json.loads(text)
          data=json_object["data"]
          total_count=json_object["total_count"]
          return locals()


      # you can add additional helper methods below.
  outputs:
    - data
    - total_count
  results:
    - SUCCESS

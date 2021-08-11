namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: workspace_body_creator
  inputs:
    - name
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(name):
          # code goes here
          jsonBody = '''
          {"data":[
            {
                "name":"''' + name + '''"
            }
           ]
          }
          '''
          return locals()
      # you can add additional helper methods below.
  outputs:
    - jsonBody
  results:
    - SUCCESS

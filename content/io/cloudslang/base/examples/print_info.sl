namespace: io.cloudslang.base.examples

operation:
  name: print_info

  inputs:
    - json_input
    - json_code

  action:
    python_script: |
      jsoninput = type(json_input)
      jsonsize= len(json_input)
      print "Type of the JSON input is:" , jsoninput
      print "Size:" ,jsonsize

  outputs:
    - json_type: ${jsoninput}
    - json_size: ${jsonsize}
    - return_code : ${json_code}
    - return_result: ${json_input}

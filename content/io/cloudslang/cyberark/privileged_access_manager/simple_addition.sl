namespace: io.cloudslang.cyberark.privileged_access_manager

operation:
  name: simple_addition

  inputs:
    - term1
    - term2

  java_action:
    gav: 'io.cloudslang.content:cs-cyberark:0.0.1-RC9'
    class_name: io.cloudslang.content.cyberark.actions.SimpleAddition
    method_name: execute

  outputs:
    - return_result: ${get('returnResult', "")}
    - return_code: ${get('returnCode', "")}
    - exception: ${get('exception', "")}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
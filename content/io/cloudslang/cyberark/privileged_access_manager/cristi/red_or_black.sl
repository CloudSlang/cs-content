namespace: io.cloudslang.cyberark.privileged_access_manager.cristi

operation:
  name: red_or_black

  inputs:
    - choice
    - bet

  java_action:
    gav: 'io.cloudslang.content:cs-cyberark:0.0.1-SNAPSHOT'
    class_name: io.cloudslang.content.cyberark.actions.cristi.RedOrBlack
    method_name: execute

  outputs:
    - return_result: ${get('returnResult', "")}
    - return_code: ${get('returnCode', "")}
    - exception: ${get('exception', "")}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

#! useless comment:
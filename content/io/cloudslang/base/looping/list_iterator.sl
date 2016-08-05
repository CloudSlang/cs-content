
namespace: io.cloudslang.base.looping

operation:
  name: list_iterator

  inputs:
    - list:
        required: False
    - delimiter:
        default: ","
    - sessionIterator:
        default: ""
        private: True

  java_action:
    gav: 'io.cloudslang.content:cs-looping:0.0.1-SNAPSHOT'
    class_name: io.cloudslang.content.actions.ListIteratorAction
    method_name: listIterator

  outputs:
    - response: ${response}
    - return_result: ${returnResult}
    - return_code: ${returnCode}

  results:
    - HAS_MORE: ${response == "has more"}
    - NO_MORE: ${response == "no more"}
    - FAILURE

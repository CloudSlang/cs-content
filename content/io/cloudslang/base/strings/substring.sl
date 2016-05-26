#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
 #   All rights reserved. This program and the accompanying materials
 #   are made available under the terms of the Apache License v2.0 which accompany this distribution.
 #
 #   The Apache License is available at
 #   http://www.apache.org/licenses/LICENSE-2.0
 ####################################################
 #!!
 #! @description: Substring from begin_index to end_index.
 #! @input string: original string - Example: "good morning"
 #! @input begin_index - begin index for the substring - Example: 0 (the first index = 0)
 #! @output end_index: end index for the substring - Example: 4 (new string will not include end_index)
 #! @output result: new string - Example: "good"
 #!!#
 ####################################################
 namespace: io.cloudslang.base.strings

 operation:
   name: substring
   inputs:
     - string
     - begin_index:
        required: false
        default: 0
     - end_index:
         required: false
         default: 0
   python_action:
     script: |
        error_message = ""
        maxIndex=len(string)+1
        if end_index==0:
            result=string[begin_index:]
        elif begin_index <= maxIndex and end_index <= maxIndex:
           result=string[begin_index:end_index]
        else:
          error_message="begin_index must be less than "+ str(maxIndex-2) +". end_index must be less than "+str(maxIndex)+ " and big than 0"
   outputs:
      - result: ${result}
      - error_message
   results:
      - SUCCESS: ${error_message==""}
      - FAILURE

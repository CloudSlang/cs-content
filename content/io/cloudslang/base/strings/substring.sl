#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
 #   All rights reserved. This program and the accompanying materials
 #   are made available under the terms of the Apache License v2.0 which accompany this distribution.
 #
 #   The Apache License is available at
 #   http://www.apache.org/licenses/LICENSE-2.0
 ####################################################
 #!!
 #! @description: Substring from beginIndex to endIndex.
 #! @input string: original string - Example: "good morning"
 #! @input beginIndex - begin index for the substring - Example: 0 (the first index = 0)
 #! @output endIndex: end index for the substring - Example: 4 (new string will not include endIndex)
 #! @output result: new string - Example: "good"
 #!!#
 ####################################################
 namespace: io.cloudslang.base.strings

 operation:
   name: substring
   inputs:
     - string
     - beginIndex:
        required: false
        default: 0
     - endIndex:
         required: false
         default: 0
   python_action:
     script: |
        error_message = ""
        maxIndex=len(string)+1
        if endIndex==0:
            result=string[beginIndex:]
        elif beginIndex <= maxIndex and endIndex <= maxIndex:
           result=string[beginIndex:endIndex]
        else:
          error_message="beginIndex must be less than "+ str(maxIndex-2) +". endIndex must be less than "+str(maxIndex)+ " and big than 0"
   outputs:
      - result: ${result}
      - error_message
   results:
      - SUCCESS: ${error_message==""}
      - FAILURE

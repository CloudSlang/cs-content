#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
 #   All rights reserved. This program and the accompanying materials
 #   are made available under the terms of the Apache License v2.0 which accompany this distribution.
 #
 #   The Apache License is available at
 #   http://www.apache.org/licenses/LICENSE-2.0
 ####################################################
 #!!
 #! @description: substring string from beginIndex to endIndex.
 #! @input string: string - Example: "good morning"
 #! @input beginIndex: position in string from which we want to cut - Example: 0 (the first index = 0)
 #! @output endIndex: position in string to which we want to cut - Example: 4 (new string will not include endIndex)
 #! @output result: new string - Example: "good"
 #! @output error_message: otherwise
 #! @results SUCCESS: the operation returns a substring
 #! @results FAILURE: something went wrong
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
        try:
          error_message = ""
          maxIndex=len(string)
          if endIndex ==0:
              result=string[beginIndex:]
          elif beginIndex < 0 and endIndex < 0:
             error_message = "beginIndex and endIndex must be bigger than 0"
          elif beginIndex > endIndex:
            error_message = "beginIndex must be lower than endIndex"
          elif beginIndex <= maxIndex and endIndex < maxIndex:
             result=string[beginIndex:endIndex]
          else:
            error_message="beginIndex must be less than "+ str(maxIndex-1) +". endIndex must be less than "+str(maxIndex)
        except TypeError:
          error_message = "substring indices must be integers"
   outputs:
      - result: ${result}
      - error_message
   results:
      - SUCCESS: ${error_message==""}
      - FAILURE

 #   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
 #   All rights reserved. This program and the accompanying materials
 #   are made available under the terms of the Apache License v2.0 which accompany this distribution.
 #
 #   The Apache License is available at
 #   http://www.apache.org/licenses/LICENSE-2.0
 ####################################################
 #!!
 #! @description: Substring sring from beginIndex to endIndex.
 #! @input origin_string: origin_string - Example: "good morning"
 #! @input beginIndex - position in string from which we want to cut - Example: 0 (the first index = 0)
 #! @output endIndex: position in string to which we want to cut - Example: 4 (new string will not include endIndex)
 #! @output new_string: new string - Example: "good"
 #!!#
 ####################################################
 namespace: io.cloudslang.base.strings

 operation:
   name: substring
   inputs:
     - origin_string
     - beginIndex
        required: false
        default: 0
     - endIndex
         required: false
         default: 0
   python_action:
     script: |
        error_message = ""
        maxIndex=len(origin_string)+1
        if endIndex==0:
            new_string=origin_string[beginIndex:]
        elif beginIndex <= maxIndex and endIndex <= maxIndex:
           new_string=origin_string[beginIndex:endIndex]
        else:
          error_message="beginIndex must be less than "+ str(maxIndex-2) +". endIndex must be less than "+str(maxIndex)+ " and big than 0"

   outputs:
      - new_string
      - error_message
   results:
      - SUCCESS: ${error_message=="" and new_string != ''}
      - FAILURE

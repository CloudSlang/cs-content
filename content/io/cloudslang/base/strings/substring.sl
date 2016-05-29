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
 #! @input begin_index - position in string from which we want to cut - Example: 0 (the first index = 0)
 #! @output end_index: position in string to which we want to cut - Example: 4 (new string will not include endIndex)
 #! @output new_string: new string - Example: "good"
 #!!#
 ####################################################
 namespace: io.cloudslang.base.strings

 operation:
   name: substring
   inputs:
     - origin_string
     - begin_index:
        default: 0
     - end_index:
         default: 0
   python_action:
     script: |
        error_message = ""
        max_index=len(origin_string)
        if end_index==0:
            new_string=origin_string[begin_index:]
        elif begin_index < max_index-1 and end_index < max_index and end_index > begin_index:
           new_string=origin_string[begin_index:end_index]
        else:
          error_message="Indexes must be end_index > begin_index, begin_index < " + str(max_index-1) + ", end_index < " + str(max_index)

   outputs:
      - new_string
      - error_message
   results:
      - SUCCESS: ${error_message=='' and new_string != ''}
      - FAILURE

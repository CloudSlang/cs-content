 #   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
 #   All rights reserved. This program and the accompanying materials
 #   are made available under the terms of the Apache License v2.0 which accompany this distribution.
 #
 #   The Apache License is available at
 #   http://www.apache.org/licenses/LICENSE-2.0
 ####################################################
 #!!
 #! @description: Substring string from begin_index to end_index.
 #! @input origin_string: origin_string - Example: "good morning"
 #! @input begin_index:  position in string from which we want to cut - Example: 0 (the first index = 0)
 #! @output end_index: position in string to which we want to cut - Example: 4 (new string will not include end_index)
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

        if isinstance(begin_index,int)==False or isinstance(end_index,int)==False:
           error_message="Invalid values"
        elif end_index==0:
            new_string=origin_string[begin_index:]
        elif end_index < 0 or begin_index < 0:
            error_message="Indexes must be positive integers"
        elif begin_index > max_index-1 or end_index > max_index:
            error_message="Indexes must be - begin_index < " + str(max_index-1) + ", end_index <= " + str(max_index)
        elif end_index < begin_index:
            error_message="Indexes must be - end_index > begin_index"
        else:
           new_string=origin_string[begin_index:end_index]



   outputs:
      - new_string
      - error_message
   results:
      - SUCCESS: ${error_message=='' and new_string != ''}
      - FAILURE

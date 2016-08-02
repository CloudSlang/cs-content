 #   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
 #   All rights reserved. This program and the accompanying materials
 #   are made available under the terms of the Apache License v2.0 which accompany this distribution.
 #
 #   The Apache License is available at
 #   http://www.apache.org/licenses/LICENSE-2.0
 ####################################################
 #!!
 #! @description: Substring of a string from begin_index to end_index.
 #! @input origin_string: origin_string - Example: "good morning"
 #! @input begin_index:  position in string from which we want to cut - Example: 0 (the first index = 0)
 #! @input end_index: position in string to which we want to cut - Example: 4 (new string will not include end_index)
 #! @output new_string: new string - Example: "good"
 #! @result SUCCESS: if error_message is empty and new_string returns a value
 #! @result FAILURE: otherwise
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
        try:
           word_length = len(origin_string)
           begin_index = int(begin_index)
           end_index = int(end_index)
           if end_index == 0:
              new_string = origin_string[begin_index:]
           elif end_index < 0 or begin_index < 0:
              error_message = "Indexes must be positive integers"
           elif begin_index >= word_length or end_index > word_length:
              error_message = "Indexes must be - begin_index < " + str(word_length) + ", end_index <= " + str(word_length)
           elif end_index < begin_index:
              error_message = "Indexes must be - end_index > begin_index"
           else:
              new_string = origin_string[begin_index : end_index]
        except (ValueError, TypeError, NameError):
           error_message = "Invalid values"

   outputs:
      - new_string
      - error_message
   results:
      - SUCCESS: ${error_message=='' and new_string != ''}
      - FAILURE

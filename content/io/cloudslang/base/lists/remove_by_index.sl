#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Removes element from list by index.
#! @input list: list from which to remove element - Example: [123, 'xyz']
#! @output index: index of the element to remove
#!!#
####################################################
namespace: io.cloudslang.base.lists

operation:
   name: remove_by_index

   inputs:
     - list
     - index
   python_action:
     script: |
       error_message = ""
       element= None

       if isinstance(index,int):
           if(abs(index) < abs(len(list))):
               element=list[index]
               list.remove(element)
           else:
             error_message = 'list has just '+ str(len(list)) + ' elements'
       elif isinstance(index,basestring):
           lengthIndex = len(index)
           valueIndex = index[1:lengthIndex]
           if index.isdigit() or (index[:1]=='-' and valueIndex.isdigit()):
              index=int(index)
              if(abs(index) < abs(len(list))):
                  element=list[index]
                  list.remove(element)
              else:
                error_message = 'list has just '+ str(len(list)) + ' elements'
           else:
             error_message = 'index must be integer'
       else:
         error_message = 'index must be integer'
   outputs:
     - result: ${list}
     - error_message
   results:
     - SUCCESS: ${error_message == ""}
     - FAILURE

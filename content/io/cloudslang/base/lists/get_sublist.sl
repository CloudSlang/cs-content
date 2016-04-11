#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Get sublist from list.
#! @input list: list from wich we want to get the sublist  - Example: [123, 'xyz']
#! @input index_start: starting index of the sublist - Example: 2
#! @input index_stop: ending index of the sublist - Example: 5
#! @input counter: get sublist element incremeted by #: - Example: 1
#! @output result: sublist
#! @output error_message: If index start is bigger than index stop or if indexes are not both integers
#! @results: SUCCESS: ${sublist != None}
#! @results: FAILURE
#!!#
####################################################
namespace: io.cloudslang.base.lists

operation:
   name: get_sublist

   inputs:
     - list
     - index_start
     - index_stop
     - counter

   action:
     python_script: |
       error_message = ""
       sublist= None
       counter=int(counter)

       if isinstance(index_start,int) and isinstance(index_stop,int):
           if(abs(index_start) and abs(index_stop) < abs(len(list))):
             if abs(index_start) < abs(index_stop):
               sublist=list[index_start:index_stop:counter]
             elif abs(index_start) > abs(index_stop):
               error_message = 'start index cannot be bigger than stop index'
           else:
             error_message = 'list has just '+ str(len(list)) + ' elements'
       else:
         error_message = 'index_start and index_stop must be both integers'

   outputs:
     - result: ${sublist}
     - error_message

   results:
     - SUCCESS: ${sublist != None}
     - FAILURE

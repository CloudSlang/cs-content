#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Count from one number to another nomber.
#! @input beginNum: the number to start counting at.
#! @result endNum: the number to count to
#! @result incrementBy: the number to increment by while counting .
#!!#
####################################################
namespace: io.cloudslang.base.utils

operation:
  name: counter
  inputs:
     - beginNum
     - endNum
     - incrementBy
  action:
    python_script: |
      beginNum=int(beginNum)
      endNum=int(endNum)
      incrementBy=int(incrementBy)
      for x in range(beginNum, endNum, incrementBy):
           print x
  outputs:
    - SUCCESS

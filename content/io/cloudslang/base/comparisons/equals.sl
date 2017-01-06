#   (c) Copyright 2014-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Compares two strings for Python equality (==).
#!
#! @input first: First string to compare.
#! @input second: Second string to compare.
#!
#! @result TRUE: Strings are equal.
#! @result FALSE: Strings are not equal.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.comparisons

decision:
  name: equals

  inputs:
    - first
    - second

  results:
    - 'TRUE': ${ first == second }
    - 'FALSE'

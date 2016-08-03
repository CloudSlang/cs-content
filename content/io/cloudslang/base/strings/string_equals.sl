#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
##################################################
#!!
#! @description: Verifies if two strings are equal.
#! @input first_string: first string to compare
#! @input second_string: second string to compare
#! @input ignore_case: If set to 'true', then the comparison ignores case considerations. The two strings are considered
#!                     equal ignoring case if they are of the same length and corresponding characters in the two strings
#!                     are equal ignoring case. If set to any value other than 'true', then the strings must match exactly
#!                     to be considered equal.
#! @result SUCCESS: strings are equal
#! @result FAILURE: strings are not equal
#!!#
##################################################
namespace: io.cloudslang.base.strings

decision:
  name: string_equals
  inputs:
    - first_string:
         required: false
    - second_string:
         required: false
    - ignore_case:
         default: false
         required: false
  results:
    - SUCCESS: ${first_string is not None and second_string is not None and ((ignore_case and first_string.lower() == second_string.lower()) or (first_string == second_string))}
    - FAILURE

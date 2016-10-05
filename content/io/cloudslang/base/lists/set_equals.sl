#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Determines whether two sets are equal.
#!               Sets are represented as trings in the following format: '1 2 3 4'
#! @input raw_set_1: optional - first set
#! @input delimiter_1: delimiter of first set - Default: `,` (comma)
#! @input raw_set_2: optional - second set
#! @input delimiter_2: delimiter of second set - Default: `,` (comma)
#! @result EQUAL: the sets are equal
#! @result NOT_EQUAL: the sets are not equal
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: set_equals
  inputs:
    - raw_set_1:
        required: false
    - delimiter_1:
        default: ','
    - raw_set_2:
        required: false
    - delimiter_2:
        default: ','
  python_action:
    script: |
      from sets import Set

      def create_set_from_str(set_as_str, delimiter):
        return Set() if (set_as_str == '') else Set(set_as_str.split(delimiter))

      set_1 = create_set_from_str(raw_set_1, delimiter_1)
      set_2 = create_set_from_str(raw_set_2, delimiter_2)
  results:
    - EQUAL: ${set_1 == set_2}
    - NOT_EQUAL

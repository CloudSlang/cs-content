Skip to content
This repository
Search
Pull requests
Issues
Gist
 @SamMarkowitz
 Unwatch 19
  Star 41
 Fork 68 CloudSlang/cloud-slang-content
 Code  Issues 48  Pull requests 11  Wiki  Pulse  Graphs  Settings
Branch: master Find file Copy pathcloud-slang-content/content/io/cloudslang/base/math/add_numbers.sl
a04b0ea  on May 13
@Bonczidai Bonczidai change action syntax
1 contributor
RawBlameHistory     30 lines (28 sloc)  1006 Bytes
#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Adds two numbers as floating point values.
#! @input value1: first value as number or string
#! @input value2: second value as number or string
#! @output result: value1 add value2
#! @result SUCCESS: always
#!!#
########################################################################################################
namespace: io.cloudslang.base.math

operation:
  name: add_numbers
  inputs:
    - value1
    - value2
  python_action:
    script: |
      value1 = float(value1)
      value2 = float(value2)
  outputs:
     - result: ${value1 + value2}

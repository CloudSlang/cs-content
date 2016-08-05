#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks if boolean is true or false. Used for flow control.
#! @input bool_value: Boolean value to check
#! @result SUCCESS: bool_value is true
#! @result FAILURE: bool_value is false
#!!#
####################################################

namespace: io.cloudslang.base.utils

decision:
  name: is_true
  inputs:
    - bool_value
  results:
    - SUCCESS: ${ bool_value in [True, true, 'True', 'true'] }
    - FAILURE

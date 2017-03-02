# (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Decision that checks the state of a System Property file.
#!
#! @result CONTAINS: System Property is set at default value.
#! @result DOES_NOT_CONTAIN: System Property is not set at default value.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.examples.yoda

decision:
  name: contains

  results:
    - CONTAINS: ${get_sp('io.cloudslang.base.examples.properties.default_quote', 'false') == 'true'}
    - DOES_NOT_CONTAIN

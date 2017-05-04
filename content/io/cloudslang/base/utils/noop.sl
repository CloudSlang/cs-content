#   (c) Copyright 2015-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: noop should do "nothing". It simulates this behavior by calling the `pass` Python statement.
#!
#! @result SUCCESS: noop should always end with success
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation:
  name: noop

  python_action:
    script: pass

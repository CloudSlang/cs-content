#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Compares two numbers as floating point values.
#! @output result: new uuid
#!!#
########################################################################################################

namespace: io.cloudslang.base.math.uuid

operation:
  name: generate_uuid

  action:
    python_script: |
      import uuid
      new_uuid = str(uuid.uuid1())
  outputs:
    - result: ${new_uuid}

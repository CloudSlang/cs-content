#   (c) Copyright 2014-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Generates a UUID.
#!
#! @output result: New uuid.
#!
#! @result SUCCESS: UUID generated successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.math

operation:
  name: generate_uuid

  python_action:
    script: |
      import uuid
      new_uuid = str(uuid.uuid1())

  outputs:
    - result: ${new_uuid}

  results:
    - SUCCESS

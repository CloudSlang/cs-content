# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Define linux or windows OS.
#
# Outputs:
#   - message - error message if error occurred
# Results:
#   - LINUX - os is linux
#   - WINDOWS - os is windows
####################################################
namespace: io.cloudslang.base.os

operation:
  name: get_os
  action:
    python_script: |
        try:
          import os
          linux = False
          if os.path.isdir('/usr'):
            linux = True
        except Exception as e:
          message = e

  outputs:
    - message

  results:
    - LINUX: linux
    - WINDOWS
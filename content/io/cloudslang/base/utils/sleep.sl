#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Sleeps for a given number of seconds.
#
# Inputs:
#   - seconds - time to sleep
# Results:
#   - SUCCESS - always
####################################################
namespace: io.cloudslang.base.utils

operation:
  name: sleep
  inputs:
    - seconds
  action:
    python_script: |
      import time
      time.sleep(float(seconds))
  results:
    - SUCCESS
# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation performs a basic print in the console. It should be used for debugging purposes.
#
# Inputs:
# - test- The text to write to console

# Results:
# - SUCCESS - operation succeeded
####################################################

namespace: org.openscore.slang.threepar
operations:
  - print:
      inputs:
        - text
      action:
        python_script: print text
      results:
        - SUCCESS

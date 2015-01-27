#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
##################################################
# Replaces a substring within a string.
#
# Inputs:
#   - input - the master string.
#   - replace - the text to replace.
#   - replaceWith - the text to replace with.
#
# Outputs:
#   - returnResult - the string with the text replaced.
#
# Results:
#   - SUCCESS - succeeded in updating string.
#   - FAILURE - was unable to replace for some reason
##################################################

namespace: org.openscore.slang.base.strings
operations:
  - searchAndReplace:
      inputs:
        - input
        - replace
        - replaceWith
      action:
        python_script: |    
          if replace in input:
            returnResult = input.replace(replace, replaceWith)
          else:
            returnResult = input 
      outputs:
        - returnResult
      results:
        - SUCCESS
        - FAILURE
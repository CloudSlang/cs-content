#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will count the occurrences of a string in another string ( *needs to be more general)
#
#   Inputs:
#       - container - String where to search
#       - toFind - String to be found
#       - ignoreCase - optional - Ignores case if set to true - Default: true
#   Outputs:
#       - occurrence - number of times toFind was found in container
#       - returnResult - notification string
#       - returnCode - 0 if everything went ok, -1 if an error was thrown
#       - errorMessage: returnResult if occurrence == '0'  else ''
#   Results:
#       - SUCCESS - string is found at least once
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.base.strings

operations:
  - string_occurrence_counter:
      inputs:
        - container
        - toFind
        - ignoreCase:
            default: "''true'"
            required: false
      action:
        python_script: |
          try:
            if ignoreCase == 'true':
              container.lower()
              toFind.lower()
            occurrence = container.count(toFind)
            returnCode = '0'
            if occurrence == 0:
              returnResult = 'Server was not created'
            else:
              returnResult = occurrence
          except:
            returnCode = '-1'
            returnResult = 'String occurrence error.'
      outputs:
        - occurrence
        - returnResult
        - returnCode
        - errorMessage: returnResult if occurrence == '0'  else ''
      results:
        - SUCCESS: occurrence >= '1'
        - FAILURE
#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#  Matches a string against a regex expression.
#
#  Inputs:
#    - regex - the regex expresssion
#    - text - the string to match
#  Outputs:
#    - match_text - the matched text
#  Results:
#    - MATCH - there was a match
#    - NO_MATCH - otherwise
####################################################
namespace: io.cloudslang.base.strings

operation:
  name: match_regex
  inputs:
    - regex
    - text
  action:
    python_script: |
      import re

      match_text = ""
      m = re.search(regex, text)
      if m is not None:
        match_text = m.group(0)
      res = False
      if match_text:
        res = True
  outputs:
    - match_text
  results:
    - MATCH: res
    - NO_MATCH
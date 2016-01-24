#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#  Tests whether a Python regex expression matches a string.
#
#  Inputs:
#    - regex - Python regex expresssion - Example: "f\\w*r"
#    - text - string to match
#  Outputs:
#    - match_text - matched text
#  Results:
#    - MATCH - a match was found
#    - NO_MATCH - no match found
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
    - MATCH: ${ res }
    - NO_MATCH

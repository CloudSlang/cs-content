#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Replaces a string in another by a regex expression.
#
# Inputs:
#   - regex - the regex expresssion
#   - text - the string to replace in
#   - replacement - the replacement string
# Outputs:
#   - result_text - the string after replacement
# Results:
#   - SUCCESS - always
####################################################
namespace: io.cloudslang.base.strings

operation:
  name: regex_replace
  inputs:
    - regex
    - text
    - replacement
  action:
    python_script: |
      import re
      result_text = ""
      result_text = re.sub(regex, replacement, text)
  outputs:
    - result_text
  results:
    - SUCCESS
#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Replaces a string in another string by a Python regex expression.
#! @input regex: Python regex expresssion - "f\\w*r"
#! @input text: optional - string to replace in
#! @input replacement: optional - replacement string
#! @output result_text: string after replacement
#! @result SUCCESS: always
#!!#
####################################################
namespace: io.cloudslang.base.strings

operation:
  name: regex_replace
  inputs:
    - regex
    - text:
        required: false
    - replacement:
        required: false
  python_action:
    script: |
      import re
      result_text = ""
      result_text = re.sub(regex, replacement, text)
  outputs:
    - result_text
  results:
    - SUCCESS

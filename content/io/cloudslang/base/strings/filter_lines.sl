#   (c) Copyright 2015-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Filters input text by string/regex, removing all lines that do not contain a match to the filter.
#!
#! @input text: Multiline text to be filtered.
#! @input filter: String or Python regex expression.
#!                Example: "f\\w*r"
#!
#! @output filter_result: Filtered text.
#!
#! @result SUCCESS: Always.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.strings

operation:
  name: filter_lines

  inputs:
    - text
    - filter

  python_action:
    script: |
      import re
      res = re.findall('.*' + filter + '.*', text)
      filter_result = '\n'.join(res)

  outputs:
    - filter_result

  results:
    - SUCCESS

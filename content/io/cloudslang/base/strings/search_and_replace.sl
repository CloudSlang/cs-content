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
#   - origin_string - original string
#   - text_to_replace - text to replace
#   - replace_with - text to replace with
# Outputs:
#   - replaced_string - string with the text replaced
# Results:
#   - SUCCESS - always
##################################################
namespace: io.cloudslang.base.strings

operation:
  name: search_and_replace
  inputs:
    - origin_string
    - text_to_replace
    - replace_with
  action:
    python_script: |
      if text_to_replace in origin_string:
        replaced_string = origin_string.replace(text_to_replace, replace_with)
      else:
        replaced_string = origin_string
  outputs:
    - replaced_string
  results:
    - SUCCESS

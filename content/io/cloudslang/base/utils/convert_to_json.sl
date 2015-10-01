#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Generates a new uuid.
#
# Outputs:
#   - json_result - json_as_string converted to json object
# Results:
#   - SUCCESS - always
####################################################
namespace: io.cloudslang.base.utils

operation:
  name: convert_to_json
  inputs:
    - json_as_string

  action:
    python_script: |
      import json
      json_result = json.loads(json_as_string)
  outputs:
    - json_result
  results:
    - SUCCESS

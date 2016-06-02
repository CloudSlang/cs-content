#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrives reference of document from json and addes it to map.
#! @input json_input: user's API Keys
#! @output key: JSON with metadata
#! @output references: map with references
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.ediscovery

operation:
  name: get_docs_references

  inputs:
     - json_input:
        sensitive: true
     - key
  python_action:
    script: |
        import json
        is_error = False
        try:
          decoded = json.loads(json_input)
          list = decoded[key]
          references = []
          for value in list:
              references.append(str(value['reference']))
        except Exception as e:
            error_message = "Error while executing json extraction: " + str(e)
            is_error = True
  outputs:
      - references
      - error_message
  results:
     - FAILURE: ${is_error}
     - SUCCESS

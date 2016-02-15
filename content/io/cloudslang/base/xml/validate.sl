#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks if given input is valid XML.
#! @input xml_input: XML to validate
#!!#
####################################################

namespace: io.cloudslang.base.xml

operation:
  name: validate

  inputs:
    - xml_input

  action:
    python_script: |
      try:
        from xml.dom import minidom
        dom = minidom.parseString(xml_input)
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_code = '-1'
        return_result = ex

  outputs:
    - return_result
    - return_code

  results:
    - VALID: ${ return_code == '0' }
    - NOT_VALID

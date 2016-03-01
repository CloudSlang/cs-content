#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!! 
#! @description: Checks if one version is older than another.(Based on python distutils.version.LooseVersion Class)
#!               Valid : 1.5.1, 1.5.2b2, 161, 3.10a, 8.02, 3.4j, 1996.07.12, 3.2.pl0, 3.1.1.6, 2g6, 11g, 0.960923, 2.2beta29, 1.13++, 5.5.kw, 2.0b1pl0
#!
#!
#! @input first_version: string which represents a version
#! @input second_version: string which represents a version
#!
#! @output error_message: error message if error occurred
#!
#! @result LESS: first_version < second_version
#! @result MORE: first_version >= second_version
#! @result FAILURE: input was not in correct format
#!!#
####################################################

namespace: io.cloudslang.base.comparisons

operation:
  name: version_comparator
  inputs:
    - first_version
    - second_version
  action:
    python_script: |
      from distutils.version import LooseVersion
      error_message = ""
      try:
        res = LooseVersion(str(first_version)) < LooseVersion(str(second_version))
      except ValueError:
        error_message = "invalid version number"

  outputs:
    - error_message
  results:
    - LOWER: ${error_message == "" and res}
    - HIGHER_OR_EQUALS: ${error_message == "" and not res}
    - FAILURE

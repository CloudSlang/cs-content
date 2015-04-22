#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.files

imports:
  files: io.cloudslang.base.files

flow:
  name: test_copy
  inputs:
    - copy_source
    - copy_destination
  workflow:
    - test_copy_operation:
        do:
          files.copy:
            - source: copy_source
            - destination: copy_destination
        navigate:
          SUCCESS: delete_copied_file
          FAILURE: COPYFAILURE
        publish:
          - message
    - delete_copied_file:
        do:
          files.delete:
            - source: copy_destination
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETEFAILURE

  outputs:
    - message

  results:
    - SUCCESS
    - COPYFAILURE
    - DELETEFAILURE


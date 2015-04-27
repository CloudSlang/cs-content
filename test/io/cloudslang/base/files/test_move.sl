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
  name: test_move
  inputs:
    - move_source
    - move_destination
  workflow:
    - test_move_operation:
        do:
          files.move:
            - source: move_source
            - destination: move_destination
    - move_back:
        do:
          files.move:
            - source: move_destination
            - destination: move_source
  results:
    - SUCCESS
    - FAILURE


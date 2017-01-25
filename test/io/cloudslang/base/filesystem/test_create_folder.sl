#   (c) Copyright 2014-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
namespace: io.cloudslang.base.filesystem

imports:
  files: io.cloudslang.base.filesystem

flow:
  name: test_create_folder

  inputs:
    - folder_name

  workflow:
    - test_create_folder_operation:
        do:
          files.create_folder:
            - folder_name
        navigate:
          - SUCCESS: delete_copied_folder
          - FAILURE: FOLDERFAILURE
    - delete_copied_folder:
        do:
          files.delete:
            - source: ${folder_name}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: DELETEFAILURE
  results:
    - SUCCESS
    - FOLDERFAILURE
    - DELETEFAILURE

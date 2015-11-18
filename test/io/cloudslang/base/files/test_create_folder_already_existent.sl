#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.files

flow:
  name: test_create_folder_already_existent
  inputs:
    - folder_name
  workflow:
    - create_folder:
        do:
          create_folder:
            - folder_name
        navigate:
          SUCCESS: test_create_folder_already_existent
          FAILURE: FOLDERFAILURE
    - test_create_folder_already_existent:
        do:
          create_folder:
            - folder_name
        navigate:
          SUCCESS: delete_folder_from_success
          FAILURE: delete_folder_from_failure
    - delete_folder_from_success:
        do:
          delete:
            - source: ${folder_name}
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETEFAILURE
    - delete_folder_from_failure:
        do:
          delete:
            - source: ${folder_name}
        navigate:
          SUCCESS: FAILURE
          FAILURE: DELETEFAILURE
  results:
    - SUCCESS
    - FOLDERFAILURE
    - DELETEFAILURE
    - FAILURE
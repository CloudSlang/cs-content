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
    - create_file_to_be_copied:
        do:
          files.write_to_file:
            - file_path: copy_source
            - text: "'text-to-be-copied'"
        navigate:
          SUCCESS: test_copy_operation
          FAILURE: create_folder_to_be_copied
    - create_folder_to_be_copied:
        do:
          files.create_folder:
            - folder_name: copy_source
        navigate:
          SUCCESS: test_copy_operation
          FAILURE: CREATEFAILURE
    - test_copy_operation:
        do:
          files.copy:
            - source: copy_source
            - destination: copy_destination
        navigate:
          SUCCESS: delete_copied_file
          FAILURE: delete_created_file_after_copy_failure
        publish:
          - message
    - delete_created_file_after_copy_failure:
        do:
          files.delete:
            - source: copy_source
        navigate:
          SUCCESS: COPYFAILURE
          FAILURE: DELETEFAILURE
    - delete_copied_file:
        do:
          files.delete:
            - source: copy_destination
        navigate:
          SUCCESS: delete_created_file
          FAILURE: DELETEFAILURE
    - delete_created_file:
        do:
          files.delete:
            - source: copy_source
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETEFAILURE

  outputs:
    - message

  results:
    - SUCCESS
    - CREATEFAILURE
    - COPYFAILURE
    - DELETEFAILURE


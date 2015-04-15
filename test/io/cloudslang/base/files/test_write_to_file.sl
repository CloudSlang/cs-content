# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Workflow to test write_to_file operation.
#
# Inputs:
#   - file_path - path to the file
#   - text - text to be written to file
# Results:
#   - SUCCESS - file written successfully
#   - WRITEFAILURE - writing to file failed
#   - DELETEFAILURE - deleting file failed
#
####################################################
namespace: io.cloudslang.base.files

imports:
  files: io.cloudslang.base.files

flow:
  name: test_write_to_file
  inputs:
    - file_path
    - text
  workflow:
    - test_write_to_file_operation:
        do:
          files.write_to_file:
            - file_path
            - text
        navigate:
          SUCCESS: delete_created_file
          FAILURE: WRITEFAILURE
    - delete_created_file:
        do:
          files.delete:
            - source: file_path
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETEFAILURE

  results:
    - SUCCESS
    - WRITEFAILURE
    - DELETEFAILURE

# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Workflow to test unzip operation.
#
# Inputs:
#   - path - path to the archive
#   - out_folder - path of folder to place unzipped files from archive
# Results:
#   - SUCCESS - archive unziped successfully
#   - ZIPFAILURE - ziping archive failed
#   - UNZIPFAILURE - unziping operation failed
#   - DELETEFAILURE - deleting archive failed
#
####################################################
namespace: io.cloudslang.base.files

imports:
  print: io.cloudslang.base.print

flow:
  name: test_unzip_archive
  inputs:
    - name
    - path
    - out_folder
  workflow:
    - prerquest_for_zip_creation:
        loop:
          for: f in [path + '/' + name + '.zip', path + '/' + name, name, name + '.zip', out_folder]
          do:
            delete:
              - source: ${f}
          break: []
        navigate:
          SUCCESS: test_folder_creation
          FAILURE: test_folder_creation

    - test_folder_creation:
        loop:
          for: folder in [path, out_folder]
          do:
            create_folder:
              - folder_name: ${folder}
          break: []
        navigate:
          SUCCESS: test_file_creation
          FAILURE: test_file_creation

    - test_file_creation:
        do:
          write_to_file:
            - file_path: ${path + '/test.txt'}
            - text: 'Workflow to test unzip operation'
        navigate:
          SUCCESS: zip_folder
          FAILURE: PREREQUESTFAILURE

    - zip_folder:
        do:
          zip_folder:
            - archive_name: ${name.split('.')[0]}
            - folder_path: ${path}
        navigate:
          SUCCESS: unzip_folder
          FAILURE: ZIPFAILURE

    - unzip_folder:
        do:
          unzip_archive:
            - archive_path: ${path + '/' + name}
            - output_folder: ${out_folder}
        publish:
            - unzip_message: ${message}
        navigate:
          SUCCESS: delete_output_folder
          FAILURE: UNZIPFAILURE

    - delete_output_folder:
        do:
          delete:
            - source: ${out_folder}
        navigate:
          SUCCESS: delete_test_folder
          FAILURE: DELETEFAILURE

    - delete_test_folder:
        do:
          delete:
            - source: ${path}
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETEFAILURE

  outputs:
    - unzip_message

  results:
    - SUCCESS
    - ZIPFAILURE
    - PREREQUESTFAILURE
    - UNZIPFAILURE
    - DELETEFAILURE
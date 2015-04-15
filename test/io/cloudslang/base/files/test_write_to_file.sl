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

namespace: io.cloudslang.base.files

imports:
  files: io.cloudslang.base.files

flow:
  name: test_delete
  inputs:
    - delete_source
  workflow:
    - create_file:
        do:
          files.write_to_file:
            - file_path: delete_source
            - text: "''"
        navigate:
          SUCCESS: test_delete_operation
          FAILURE: WRITEFAILURE
    - test_delete_operation:
        do:
          files.delete:
            - source: delete_source
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETEFAILURE


  results:
    - SUCCESS
    - WRITEFAILURE
    - DELETEFAILURE
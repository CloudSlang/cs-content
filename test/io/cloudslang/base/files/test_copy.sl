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
    - delete_copied_file:
        do:
          files.delete:
            - source: copy_destination
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETEFAILURE

  results:
    - SUCCESS
    - COPYFAILURE
    - DELETEFAILURE


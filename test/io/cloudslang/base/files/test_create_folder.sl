namespace: io.cloudslang.base.files

imports:
  files: io.cloudslang.base.files

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
          SUCCESS: delete_copied_file
          FAILURE: FOLDERFAILURE
    - delete_copied_file:
        do:
          files.delete:
            - source: folder_name
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETEFAILURE
  results:
    - SUCCESS
    - FOLDERFAILURE
    - DELETEFAILURE
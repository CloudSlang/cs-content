namespace: io.cloudslang.base.files

imports:
  files: io.cloudslang.base.files
  strings: io.cloudslang.base.strings

flow:
  name: test_zip_folder
  inputs:
    - archive_name
    - folder_path
  workflow:
    - test_zip_folder_operation:
        do:
          files.zip_folder:
            - archive_name
            - folder_path
        navigate:
          SUCCESS: delete_archive
          FAILURE: ZIPFAILURE
    - delete_archive:
        do:
          files.delete:
            - source: "'./' + folder_path + '/' + archive_name + '.zip'"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETEFAILURE
  results:
    - SUCCESS
    - ZIPFAILURE
    - DELETEFAILURE




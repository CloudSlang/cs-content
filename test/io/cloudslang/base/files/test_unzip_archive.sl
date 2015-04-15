namespace: io.cloudslang.base.files

imports:
  files: io.cloudslang.base.files
  utils: io.cloudslang.base.utils
flow:
  name: test_unzip_archive
  inputs:
    - path
    - out_folder
  workflow:
    - zip_check:
        do:
          files.delete:
            - source:
                default: "'./test/' + path"
                overridable: false
        navigate:
          SUCCESS: zip_folder
          FAILURE: zip_folder
    - zip_folder:
        do:
          files.zip_folder:
            - archive_name: path.split('.')[0]
            - folder_path: "'test'"
        navigate:
          SUCCESS: unzip_folder
          FAILURE: ZIPFAILURE
    - unzip_folder:
        do:
          files.unzip_archive:
            - archive_path:
                default: "'./test/' + path"
                overridable: false
            - output_folder: out_folder
        navigate:
          SUCCESS: delete_output_folder
          FAILURE: UNZIPFAILURE
    - delete_output_folder:
        do:
          files.delete:
            - source:
                default: out_folder
                overridable: false
        navigate:
          SUCCESS: delete_archive
          FAILURE: DELETEFAILURE

    - delete_archive:
        do:
          files.delete:
            - source:
                default: "'./test/' + path"
                overridable: false
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETEFAILURE

  results:
    - SUCCESS
    - ZIPFAILURE
    - UNZIPFAILURE
    - DELETEFAILURE

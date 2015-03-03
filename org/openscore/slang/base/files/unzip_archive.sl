namespace: task.zip

operation:
  name: unzip_archive
  inputs:
    - archive_name
    - output_folder

  action:
    python_script: |
        import zipfile, sys
        try:
          with zipfile.ZipFile(archive_name, "r") as z:
            z.extractall(output_folder)
          res = 'True'
        except Exception as e:
          print (e)
          print sys.exc_info()[0]
          res = 'False'

  results:
    - SUCCESS: res == 'True'
    - FAILURE: res == 'False'
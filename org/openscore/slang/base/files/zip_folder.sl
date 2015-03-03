namespace: task.zip

operation:
  name: zip_folder
  inputs:
    - archive_name
    - folder_path
    - output_folder

  action:
    python_script: |
        import sys, os, shutil
        try:
          shutil.make_archive(archive_name, "zip", folder_path)
          filename = archive_name + '.zip'
          if os.path.isdir(output_folder):
            shutil.move(filename, output_folder)
          else:
            print ("else")
            os.mkdir(output_folder)
            shutil.move(filename, output_folder)
          res = 'True'
        except Exception:
          print sys.exc_info()[0]
          res = 'False'

  results:
    - SUCCESS: res == 'True'
    - FAILURE: res == 'False'
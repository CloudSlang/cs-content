namespace: org.openscore.slang.base.files

operation:
  name: write_to_file
  inputs:
    - file_path
    - text
  action:
    python_script: |
      try:
        f = open(file_path, 'w')
        f.write(text)
        f.close()
        res = 'True'
      except:
        print sys.exc_info()[0]
        res = 'False'
  results:
    - SUCCESS: res == 'True'
    - FAILURE
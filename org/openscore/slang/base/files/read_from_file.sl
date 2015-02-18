namespace: org.openscore.slang.base.files

operation:
  name: read_from_file
  inputs:
    - file_path
  action:
    python_script: |
      import sys
      try:
        f = open(file_path, 'r')
        read_text = f.read()
        f.close()
        res = 'True'
      except:
        print sys.exc_info()[0]
        res = 'False'
  outputs:
    - read_text
  results:
    - SUCCESS: res == 'True'
    - FAILURE
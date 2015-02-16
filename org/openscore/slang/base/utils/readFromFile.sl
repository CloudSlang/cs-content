namespace: flow.actions
# imports:
operations:
  - readFromFile:
      inputs:
        - filePath
      action:
        python_script: |
          import sys
          try:
            f = open(filePath, 'r')
            readText = f.read()
            f.close()
            res = 'True'
          except:
            print sys.exc_info()[0]
            res = 'False'
      outputs:
        - readText: readText
      results:
        - SUCCESS: res == 'True'
        - FAILURE
namespace: flow.actions
# imports:
operations:
  - writeToFile:
      inputs:
        - filePath
        - text
      action:
        python_script: |
          try:
            f = open(filePath, 'w')
            f.write(text)
            f.close()
            res = 'True'
          except:
            print sys.exc_info()[0]
            res = 'False'
      results:
        - SUCCESS: res == 'True'
        - FAILURE
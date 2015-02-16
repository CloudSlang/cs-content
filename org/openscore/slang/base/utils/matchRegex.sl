namespace: flow.actions
# imports:
operations:
  - matchRegex:
      inputs:
        - regex
        - text
      action:
        python_script: |
          import re
          m = re.search(regex, text)
          matchText = m.group(0)
          res = 'False'
          if matchText:
            res = 'True'
      outputs:
        - matchText: matchText
      results:
        - TRUE1: res == 'True'
        - FALSE1
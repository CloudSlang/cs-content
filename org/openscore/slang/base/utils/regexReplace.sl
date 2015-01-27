namespace: flow.actions
# imports:
operations:
  - regexReplace:
      inputs:
        - regex
        - text
        - replacement
      action:
        python_script: |
          import re
          resultText = re.sub(regex, replacement, text)
      outputs:
        - resultText: resultText
      results:
        - SUCCESS
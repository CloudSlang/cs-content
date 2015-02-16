namespace: flow.actions
# imports:
operations:
  - loop:
      inputs:
        - fromInput
        - toInput
      action:
        python_script: |
          res = fromInput <= toInput
          out = int(fromInput) + 1
      outputs:
        - fromInput: out
      results:
        - HAS_MORE: res == 'True'
        - DONE
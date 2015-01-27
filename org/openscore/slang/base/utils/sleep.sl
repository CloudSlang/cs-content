namespace: flow.actions
# imports:
operations:
  - sleep:
      inputs:
        - seconds
      action:
        python_script: |
          import time
          time.sleep(float(seconds))
      results:
        - SUCCESS
namespace: org.openscore.slang.base.utils

operation:
  name: sleep
  inputs:
    - seconds
  action:
    python_script: |
      import time
      time.sleep(float(seconds))
  results:
    - SUCCESS
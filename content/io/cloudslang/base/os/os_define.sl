namespace: io.cloudslang.base.os

operation:
  name: os_define
  action:
    python_script: |
        try:
          import os
          linux = False
          if os.path.isdir('/usr'):
            linux = True
        except Exception as e:
          message = e

  outputs:
    - message

  results:
    - LINUX: linux
    - WINDOWS
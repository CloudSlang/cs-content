namespace: flow.actions
# imports:
operations:
  - uuidGenerator:
      action:
        python_script: |
          import uuid
          newUuid = str(uuid.uuid1())
          print newUuid
      outputs:
        - newUuid: newUuid
      results:
        - SUCCESS
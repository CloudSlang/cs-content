namespace: org.openscore.slang.base.utils

operation:
  name: uuid_generator
  action:
    python_script: |
      import uuid
      new_uuid = str(uuid.uuid1())
      print new_uuid
  outputs:
    - new_uuid
  results:
    - SUCCESS
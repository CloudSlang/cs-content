namespace: org.openscore.slang.base.strings

operation:
  name: regex_replace
  inputs:
    - regex
    - text
    - replacement
  action:
    python_script: |
      import re
      result_text = re.sub(regex, replacement, text)
  outputs:
    - result_text
  results:
    - SUCCESS
namespace: org.openscore.slang.base.strings

operation:
  name: match_regex
  inputs:
    - regex
    - text
  action:
    python_script: |
      import re
      m = re.search(regex, text)
      match_text = m.group(0)
      res = 'False'
      if match_text:
        res = 'True'
  outputs:
    - match_text
  results:
    - MATCH: res == 'True'
    - NO_MATCH
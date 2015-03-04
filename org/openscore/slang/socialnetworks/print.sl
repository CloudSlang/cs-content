namespace: org.openscore.slang.twitter
operations:
  - print:
      inputs:
        - text
      action:
        python_script: print text
      results:
        - SUCCESS

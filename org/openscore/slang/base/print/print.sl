namespace: org.openscore.slang.base.print

operations:
  - print:
      inputs:
        - text
      action:
        python_script: print text
      results:
        - SUCCESS
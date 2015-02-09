namespace: org.openscore.slang.base.print

operation:
      name: print_text
      inputs:
        - text
      action:
        python_script: print text
      results:
        - SUCCESS
# (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
########################################################################################################################
#!!
#! @description: Based on a random number generator display a quote from Yoda
#!
#! @input file_path: The path for the file that contains the quotes
#!
#! @result SUCCESS: Flow completed successfully.
#! @result FAILURE: Failure occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.samples.yoda

imports:
  math: io.cloudslang.base.math
  base: io.cloudslang.base.print
  fs: io.cloudslang.base.filesystem

flow:
    name: generate_random_quote

    inputs:
      - file_path

    workflow:
      - read_quotes:
          do:
            fs.read_from_file:
              - file_path: ${file_path}
          publish:
            - read_text
          navigate:
            - SUCCESS: generate_random_number
            - FAILURE: FAILURE

      - generate_random_number:
          do:
            math.random_number_generator:
              - min: '0'
              - max: ${str(len(read_text.strip().split(';')) - 2)}
          publish:
            - random_number
          navigate:
            - SUCCESS: print_quote
            - FAILURE: FAILURE

      - print_quote:
          do:
            base.print_text:
              - text: ${str(read_text.split(';')[int(random_number)])}
          navigate:
            - SUCCESS: SUCCESS
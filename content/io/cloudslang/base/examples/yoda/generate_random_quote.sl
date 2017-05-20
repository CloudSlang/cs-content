# (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
########################################################################################################################
#!!
#! @description: The flow displays a Yoda quote based on a random number generator.
#!
#! @input file_path: The path for the file that contains the quotes.
#!
#! @output quotes: A list with all the quotes from the file.
#! @output random_quote: The quote randomly selected.
#!
#! @result SUCCESS: The quote was displayed successfully.
#! @result FAILURE: Failure occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.examples.yoda

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
            - file_path
        publish:
          - read_text
          - quotes : ${str(read_text).replace('\n','')}
        navigate:
          - SUCCESS: generate_random_number
          - FAILURE: FAILURE

    - generate_random_number:
        do:
          math.random_number_generator:
            - min: '0'
            - max: ${str(len(quotes.strip().split(';')) - 2)}
            - quotes
        publish:
          - random_number
          - random_quote: ${str(quotes.split(';')[int(random_number)])}
        navigate:
          - SUCCESS: print_quote
          - FAILURE: FAILURE

    - print_quote:
        do:
          base.print_text:
            - text: ${str(random_quote)}
        navigate:
          - SUCCESS: SUCCESS

  outputs:
      - quotes
      - random_quote

  results:
      - SUCCESS
      - FAILURE
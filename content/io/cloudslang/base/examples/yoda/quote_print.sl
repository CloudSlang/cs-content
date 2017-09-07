#   (c) Copyright 2015-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Prints a random quote from a given file, first it reads the contents of the file, then selects a random row.
#!
#! @input file_path_quote: Path input.
#!                    Example: C:\folder1\folder2\textFile.txt
#!
#!
#! @result SUCCESS: The operation executed successfully
#! @result FAILURE: The operation could not be executed
#!!#
########################################################################################################################

namespace: io.cloudslang.base.examples.yoda

imports:
  math: io.cloudslang.base.math
  print: io.cloudslang.base.print
  file: io.cloudslang.base.filesystem


flow:
  name: quote_print
  inputs:
    - file_path_quote
  workflow:
    - read_ascii_file:
        do:
          file.read_from_file:
            - file_path: ${file_path_quote}
        publish:
          - file_content: ${read_text}

    - count_file_lines:
        do:
          count_lines:
            - text: ${file_content}
        publish:
            - number_of_lines: ${number_of_lines}

    - get_quote_number:
        do:
          math.random_number_generator:
            - min: '0'
            - max: ${number_of_lines}
        publish:
          - number: ${random_number}

    - get_quote:
        do:
          read_nth_line:
            - text : ${file_content}
            - line_number: ${number}
        publish:
          - quote: ${line}

    - print_quote:
        do:
          print.print_text:
            - text: ${quote}
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
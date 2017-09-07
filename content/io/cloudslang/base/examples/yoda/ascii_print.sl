#   (c) Copyright 2015-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Reads all the content from a file then displays it.
#!
#! @input file_path_ascii: Path  input.
#!                    Example: file_path_ascii=C:\Work\cs-content\content\file.txt
#!
#!
#! @result SUCCESS: The operation executed successfully
#! @result FAILURE: The operation could not be executed
#!!#
########################################################################################################################

namespace: io.cloudslang.base.examples.yoda

imports:
  print: io.cloudslang.base.print
  file: io.cloudslang.base.filesystem

flow:
  name: ascii_print
  inputs:
    - file_path_ascii
  workflow:
    - get_ascii:
        do:
          file.read_from_file:
            - file_path: ${file_path_ascii}
        publish:
          - ascii_art: ${read_text}
    - print_ascii:
        do:
          print.print_text:
            - text: ${ascii_art}
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
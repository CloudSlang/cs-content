# (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: The flow reads an image of Yoda from a file and prints it to the screen.
#!
#! @input file_path: The path of the file containing the image.
#!
#! @result SUCCESS: The image was displayed successfully.
#! @result FAILURE: Failure occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.examples.yoda

imports:
  base: io.cloudslang.base.print
  fs: io.cloudslang.base.filesystem

flow:
  name: print_image

  inputs:
    - file_path

  workflow:
    - read_start:
        do:
          fs.read_from_file:
            - file_path
        publish:
          - read_text
        navigate:
          - SUCCESS: print_start
          - FAILURE: FAILURE

    - print_start:
        do:
          base.print_text:
            - text: ${read_text}
        navigate:
          - SUCCESS: SUCCESS

  results:
        - SUCCESS
        - FAILURE
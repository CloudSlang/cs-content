#   (c) Copyright 2015-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Starts all the flows need for the Yoda example
#!               If default quote is set, it will display it, if not it will display a randome quote from the text file.
#!
#! @input file_path_ascii: Path  input.
#!                    Example: file_path_ascii=C:\Work\cs-content\content\file.txt
#! @input file_path_quote: Path  input.
#!                    Example: file_path_quote=C:\Work\cs-content\content\file.txt
#!
#!
#! @result SUCCESS: The operation executed successfully
#! @result FAILURE: The operation could not be executed
#!!#
########################################################################################################################

namespace: io.cloudslang.base.examples.yoda
#run command
#run --f C:/Work/cs-content/content/io/cloudslang/base/examples/yoda/yoda.sl --cp C:/Work/cs-content/content --i file_path_ascii=C:\Work\cs-content\content\io\cloudslang\base\examples\yoda\asciiArt.txt,file_path_quote=C:\Work\cs-content\content\io\cloudslang\base\examples\yoda\quotes.txt --spf C:\Work\cs-content\content\io\cloudslang\base\examples\yoda\yoda_properties.prop.sl
imports:
  print: io.cloudslang.base.print
  equals: io.cloudslang.base.comparisons

flow:
  name: yoda
  inputs:
    - file_path_ascii
    - file_path_quote
  workflow:
    - read_and_print_ascii:
        do:
          ascii_print:
            - file_path_ascii: ${file_path_ascii}
        navigate:
          - SUCCESS: check_system_properties
          - FAILURE: FAILURE

    - check_system_properties:
        do:
          equals.equals:
            - first: ${get_sp('io.cloudslang.base.examples.yoda.properties.default_quote', 'Not')}
            - second: 'Not'
        navigate:
          - 'TRUE': print_yoda_quote
          - 'FALSE': print_system_property

    - print_yoda_quote:
        do:
          quote_print:
            - file_path_quote: ${file_path_quote}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

    - print_system_property:
        do:
          print.print_text:
            - text: ${get_sp('io.cloudslang.base.examples.yoda.properties.default_quotet', 'Not')}
        navigate:
          - SUCCESS: SUCCESS


  results:
    - SUCCESS
    - FAILURE

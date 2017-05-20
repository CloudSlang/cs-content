# (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description:  This flow displays a random Yoda quote, based on a system properties file.
#!                If it is set on true it displays the default quote, otherwise generates a random quote.
#!
#! @input default_quote : Quote with a default value.
#! @input file_path: The path for the file that contains the quotes.
#!
#! @output random_quote: The quote that is chosen after the system property check.
#!
#! @result SUCCESS: Flow completed successfully.
#! @result FAILURE: Failure occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.examples.yoda

imports:
  math: io.cloudslang.base.math
  base: io.cloudslang.base.print
  utils: io.cloudslang.base.utils
  fs: io.cloudslang.base.filesystem
  quote_generator: io.cloudslang.base.examples.yoda

flow:
  name: quote_check

  inputs:
    - default_quote:
        default: 'Do or do not, there is no try!'
        private: true
    - file_path:
        default: ${get_sp('io.cloudslang.base.examples.yoda.file_path')}
        required: false

  workflow:
    - check_system_property:
        do:
          utils.is_true:
          - bool_value: ${get_sp('io.cloudslang.base.examples.yoda.default_quote', 'false')}
        navigate:
          - 'TRUE': print_default_quote
          - 'FALSE': print_random_quote

    - print_random_quote:
        do:
          quote_generator.generate_random_quote:
            - file_path
        publish:
          - random_quote
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

    - print_default_quote:
        do:
          base.print_text:
            - text: ${default_quote}
        navigate:
          - SUCCESS: SUCCESS

  outputs:
    - random_quote

  results:
    - SUCCESS
    - FAILURE